#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ai-wofi.py - Python version of the ai-wofi Wayland assistant

This script provides a GUI interface for various AI interactions using the wofi
menu system on Wayland. It allows querying AI models, rewriting text,
generating shell commands, and working with code.

Features:
- Quick AI queries with clipboard integration
- Text rewriting and transformation
- Command generation and execution
- Code analysis and transformation
- Chat sessions with AI models
- Role-based interactions
- History management

Dependencies: aichat, wofi, wl-copy, wl-paste, notify-send, jq
"""

import os
import sys
import json
import time
import tempfile
import re
import subprocess
import shutil
import signal
import datetime
from pathlib import Path
import atexit

# Constants
SCRIPT_NAME = os.path.basename(__file__)
VERSION = "0.0.1"

# Configuration
CONFIG_DIR = os.path.join(os.environ.get("XDG_CONFIG_HOME", os.path.expanduser("~/.config")), "wofi-ai")
CACHE_DIR = os.path.join(os.environ.get("XDG_CACHE_HOME", os.path.expanduser("~/.cache")), "wofi-ai")
LOG_FILE = os.path.join(CACHE_DIR, "error.log")
HISTORY_FILE = os.path.join(CACHE_DIR, "history.jsonl")
MODELS_CACHE = os.path.join(CACHE_DIR, "models.cache")
ROLES_CACHE = os.path.join(CACHE_DIR, "roles.cache")

# Default settings (can be overridden by ai-wofi-settings)
AI_WOFI_MODEL = ""
AI_WOFI_CODE_MODEL = ""
AI_WOFI_CHAT_MODEL = ""
AI_WOFI_TIMEOUT = 30
AI_WOFI_TERMINAL = "foot"

# Consistent wofi styling - 800x800, 50x50 from top-left
WOFI_ARGS = "--width=800 --height=800 --xoffset=50 --yoffset=50 --location=top_left"

# Get the directory where this script is located
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))

# Cleanup function
def cleanup():
    """Remove any temp files created by this process"""
    for temp_file in Path('/tmp').glob(f"wofi-ai-{os.getpid()}-*"):
        try:
            temp_file.unlink()
        except (OSError, PermissionError):
            pass

# Register cleanup handler
atexit.register(cleanup)

# Initialize directories
def init_directories():
    """Create necessary directories if they don't exist"""
    os.makedirs(CONFIG_DIR, exist_ok=True)
    os.makedirs(CACHE_DIR, exist_ok=True)

# Logging function with rotation and sanitization
def log_error(error_msg, context="Unknown context"):
    """Log errors to file with rotation and sanitization"""
    timestamp = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    
    # Truncate long errors
    error_msg = error_msg[:500]
    
    # Remove potential secrets (API keys, tokens)
    error_msg = re.sub(r'[0-9a-f]{32,}', '[REDACTED_KEY]', error_msg)
    
    # Rotate log if too large (1MB)
    try:
        if os.path.exists(LOG_FILE) and os.path.getsize(LOG_FILE) > 1048576:
            if os.path.exists(f"{LOG_FILE}.old"):
                os.unlink(f"{LOG_FILE}.old")
            os.rename(LOG_FILE, f"{LOG_FILE}.old")
    except (OSError, PermissionError) as e:
        print(f"Error rotating log file: {e}", file=sys.stderr)
    
    # Log to file
    try:
        with open(LOG_FILE, "a") as log:
            log.write(f"[{timestamp}] [{context}] {error_msg}\n")
    except (OSError, PermissionError) as e:
        print(f"Error writing to log file: {e}", file=sys.stderr)
    
    # Also show in notification
    try:
        subprocess.run(["notify-send", "AI Error", f"{error_msg}\n\nCheck log: {LOG_FILE}", "-u", "critical"], 
                      check=False)
    except Exception:
        pass

# Execute command and return output
def execute_command(cmd, input_text=None, timeout=None):
    """Execute a command and return its output"""
    try:
        result = subprocess.run(
            cmd, 
            input=input_text.encode('utf-8') if input_text else None,
            stdout=subprocess.PIPE, 
            stderr=subprocess.PIPE,
            timeout=timeout,
            check=False
        )
        return result.stdout.decode('utf-8').strip(), result.stderr.decode('utf-8').strip(), result.returncode
    except subprocess.TimeoutExpired:
        return "", "Command timed out", 124
    except Exception as e:
        return "", str(e), 1

# Save to history
def save_to_history(prompt, response, model=None):
    """Save the prompt and response to history"""
    if not prompt or not response:
        return
    
    model = model or AI_WOFI_MODEL
    
    # Create a JSON object
    entry = {
        "timestamp": datetime.datetime.now().isoformat(),
        "model": model,
        "prompt": prompt,
        "response": response
    }
    
    try:
        # Check if history file exists and has content
        if os.path.exists(HISTORY_FILE) and os.path.getsize(HISTORY_FILE) > 0:
            # Check if it's a JSONL file by counting braces at the beginning of lines
            with open(HISTORY_FILE, 'r') as f:
                content = f.read()
            
            if len(re.findall(r'^\{', content, re.MULTILINE)) > 1:
                # It's a JSONL file, append as new line
                with open(HISTORY_FILE, 'a') as f:
                    f.write(json.dumps(entry) + '\n')
            else:
                # It's a single JSON object, convert to JSONL by writing both entries
                with open(f"{HISTORY_FILE}.new", 'w') as f:
                    f.write(json.dumps(entry) + '\n')
                    f.write(content)
                os.rename(f"{HISTORY_FILE}.new", HISTORY_FILE)
        else:
            # Create new file
            with open(HISTORY_FILE, 'w') as f:
                f.write(json.dumps(entry) + '\n')
    except Exception as e:
        log_error(f"Error saving to history: {e}", "save_to_history")

# Clean old cache files
def cleanup_old_files():
    """Remove code responses older than 7 days and trim history"""
    # Remove code responses older than 7 days
    try:
        for file in Path(CACHE_DIR).glob("code_response_*.md"):
            if (datetime.datetime.now() - datetime.datetime.fromtimestamp(file.stat().st_mtime)).days > 7:
                file.unlink()
    except Exception:
        pass
    
    # Keep only last 1000 history entries
    try:
        if os.path.exists(HISTORY_FILE):
            with open(HISTORY_FILE, 'r') as f:
                lines = f.readlines()
            
            if len(lines) > 1000:
                with open(f"{HISTORY_FILE}.tmp", 'w') as f:
                    f.writelines(lines[-1000:])
                os.rename(f"{HISTORY_FILE}.tmp", HISTORY_FILE)
    except Exception:
        pass

# Safe config loading
def load_config():
    """Load configuration from file safely"""
    global AI_WOFI_MODEL, AI_WOFI_CODE_MODEL, AI_WOFI_CHAT_MODEL, AI_WOFI_TIMEOUT, AI_WOFI_TERMINAL
    
    config_file = f"{CONFIG_DIR}/config"
    if os.path.exists(config_file):
        try:
            with open(config_file, 'r') as f:
                for line in f:
                    if '=' in line:
                        key, value = line.strip().split('=', 1)
                        # Remove quotes
                        value = value.strip('"\'')
                        
                        if key in ('AI_WOFI_MODEL', 'AI_WOFI_CHAT_MODEL', 'AI_WOFI_CODE_MODEL', 'AI_WOFI_TIMEOUT', 'AI_WOFI_TERMINAL'):
                            # Validate that value doesn't contain dangerous characters
                            if re.match(r'^[a-zA-Z0-9_:./-]+$', value):
                                if key == 'AI_WOFI_MODEL':
                                    AI_WOFI_MODEL = value
                                elif key == 'AI_WOFI_CHAT_MODEL':
                                    AI_WOFI_CHAT_MODEL = value
                                elif key == 'AI_WOFI_CODE_MODEL':
                                    AI_WOFI_CODE_MODEL = value
                                elif key == 'AI_WOFI_TIMEOUT':
                                    AI_WOFI_TIMEOUT = int(value)
                                elif key == 'AI_WOFI_TERMINAL':
                                    AI_WOFI_TERMINAL = value
        except Exception as e:
            log_error(f"Error loading config: {e}", "load_config")

# Load settings from ai-wofi-settings file
def load_settings():
    """Load settings from ai-wofi-settings file"""
    global AI_WOFI_MODEL, AI_WOFI_CODE_MODEL, AI_WOFI_CHAT_MODEL, AI_WOFI_TIMEOUT, AI_WOFI_TERMINAL, WOFI_ARGS
    
    # Check in order: script directory, config directory, home directory
    settings_files = [
        f"{SCRIPT_DIR}/ai-wofi-settings",
        f"{CONFIG_DIR}/ai-wofi-settings",
        os.path.expanduser("~/.ai-wofi-settings")
    ]
    
    for settings_file in settings_files:
        if os.path.exists(settings_file):
            try:
                # Use a simple approach to source the bash file
                with open(settings_file, 'r') as f:
                    for line in f:
                        line = line.strip()
                        if line and not line.startswith('#') and '=' in line:
                            key, value = line.split('=', 1)
                            # Remove quotes
                            value = value.strip('"\'')
                            
                            if key == 'AI_WOFI_DEFAULT_MODEL':
                                AI_WOFI_MODEL = value
                            elif key == 'AI_WOFI_CODE_MODEL':
                                AI_WOFI_CODE_MODEL = value
                            elif key == 'AI_WOFI_CHAT_MODEL':
                                AI_WOFI_CHAT_MODEL = value
                            elif key == 'AI_WOFI_TIMEOUT':
                                AI_WOFI_TIMEOUT = int(value)
                            elif key == 'AI_WOFI_TERMINAL':
                                AI_WOFI_TERMINAL = value
                            elif key == 'WOFI_ARGS':
                                WOFI_ARGS = value
                break
            except Exception as e:
                log_error(f"Error loading settings: {e}", "load_settings")
    
    # Default settings (can be overridden by ai-wofi-settings)
    AI_WOFI_CODE_MODEL = AI_WOFI_CODE_MODEL or AI_WOFI_MODEL
    AI_WOFI_CHAT_MODEL = AI_WOFI_CHAT_MODEL or AI_WOFI_MODEL

# Check dependencies
def check_dependencies():
    """Check if all required dependencies are installed"""
    missing = []
    
    for cmd in ["aichat", "wofi", "wl-copy", "wl-paste", "notify-send", "jq"]:
        if not shutil.which(cmd):
            missing.append(cmd)
    
    if missing:
        error_msg = f"Missing dependencies: {' '.join(missing)}"
        print(f"Error: {error_msg}", file=sys.stderr)
        try:
            subprocess.run(["notify-send", "Missing Dependencies", f"Please install: {' '.join(missing)}", "-u", "critical"], 
                          check=False)
        except Exception:
            pass
        return False
    
    return True

# Check if aichat is accessible
def check_aichat():
    """Check if aichat is accessible and working"""
    stdout, stderr, exit_code = execute_command(["aichat", "--list-models"])
    
    if exit_code != 0:
        log_error(f"Cannot connect to AI service. Error: {stderr}", "check_aichat")
        
        # Check if it's an Ollama connection issue
        if "ollama" in stderr or "connection" in stderr:
            try:
                subprocess.run(["notify-send", "Ollama Connection Error", "Make sure Ollama is running:\nollama serve", "-u", "critical"], 
                              check=False)
            except Exception:
                pass
        
        return False
    return True

# Get available models with caching
def get_models_cached():
    """Get available models with caching"""
    # Refresh cache if older than 1 hour or doesn't exist
    if not os.path.exists(MODELS_CACHE) or (time.time() - os.path.getmtime(MODELS_CACHE) > 3600):
        temp_file = f"{MODELS_CACHE}.tmp"
        
        # Get models from aichat
        stdout, stderr, exit_code = execute_command(["aichat", "--list-models"])
        
        if exit_code != 0:
            log_error(f"aichat --list-models failed: {stderr}", "get_models_cached")
            return []
        
        # Remove empty lines
        models = [line for line in stdout.split('\n') if line.strip()]
        
        # Check if we got any models
        if not models:
            log_error("No models found in aichat output", "get_models_cached")
            return []
        
        # Write to cache
        try:
            with open(MODELS_CACHE, 'w') as f:
                f.write('\n'.join(models))
        except Exception as e:
            log_error(f"Error writing to models cache: {e}", "get_models_cached")
            return models
    
    # Read from cache
    try:
        with open(MODELS_CACHE, 'r') as f:
            return [line.strip() for line in f if line.strip()]
    except Exception as e:
        log_error(f"Error reading from models cache: {e}", "get_models_cached")
        return []

# Get first available model as fallback
def get_first_available_model():
    """Get first available model as fallback"""
    models = get_models_cached()
    return models[0] if models else ""

# Validate model exists
def validate_model(model):
    """Check if a model exists"""
    if not model:
        return False
    
    models = get_models_cached()
    return model in models

# Get model for specific mode
def get_model_for_mode(mode):
    """Get the appropriate model for a specific mode"""
    global AI_WOFI_MODEL, AI_WOFI_CODE_MODEL, AI_WOFI_CHAT_MODEL
    
    if mode == "code":
        return AI_WOFI_CODE_MODEL or AI_WOFI_MODEL
    elif mode == "chat":
        return AI_WOFI_CHAT_MODEL or AI_WOFI_MODEL
    else:
        return AI_WOFI_MODEL

# Get roles with caching
def get_roles_cached():
    """Get available roles with caching"""
    if not os.path.exists(ROLES_CACHE) or (time.time() - os.path.getmtime(ROLES_CACHE) > 3600):
        stdout, stderr, exit_code = execute_command(["aichat", "--list-roles"])
        
        if exit_code == 0 and stdout:
            with open(ROLES_CACHE, 'w') as f:
                f.write(stdout)
    
    if os.path.exists(ROLES_CACHE):
        with open(ROLES_CACHE, 'r') as f:
            return [line.strip() for line in f if line.strip()]
    
    return []

# Run wofi with input and return selection
def run_wofi(prompt, options, allow_custom_input=False, multiline=False):
    """Run wofi with given options and return selection"""
    cmd = ["wofi", "--dmenu", "-p", prompt]
    
    # Add WOFI_ARGS as separate arguments, properly handling quoted strings
    import shlex
    cmd.extend(shlex.split(WOFI_ARGS))
    
    if allow_custom_input:
        cmd.append("-k")
    
    if multiline:
        cmd.extend(["-l", "20"])  # Show more lines for multiline content
    
    options_str = '\n'.join(options)
    
    stdout, stderr, exit_code = execute_command(cmd, options_str)
    
    if exit_code != 0:
        return None
    
    return stdout

# Send request through aichat with timeout and error handling
def ai_request(prompt, model=None, role=None, context="ai_request"):
    """Send request to AI and handle response"""
    global AI_WOFI_MODEL, AI_WOFI_TIMEOUT
    
    model = model or AI_WOFI_MODEL
    
    # Show which model is being used
    try:
        subprocess.run(["notify-send", "AI Assistant", f"Using model: {model}\nProcessing...", "-t", "2000"], check=False)
    except Exception:
        pass
    
    # Create temp files for output and errors
    with tempfile.NamedTemporaryFile(prefix=f"wofi-ai-{os.getpid()}-out.", delete=False) as temp_out, \
         tempfile.NamedTemporaryFile(prefix=f"wofi-ai-{os.getpid()}-err.", delete=False) as temp_err:
        temp_out_path = temp_out.name
        temp_err_path = temp_err.name
    
    # Build command
    cmd = ["timeout", str(AI_WOFI_TIMEOUT), "aichat", "--model", model]
    if role:
        cmd.extend(["--role", role])
    
    # Execute command with timeout
    try:
        stdout, stderr, exit_code = execute_command(cmd, prompt, timeout=AI_WOFI_TIMEOUT+5)
        
        # Write output and errors to temp files (for debugging)
        with open(temp_out_path, 'w') as f:
            f.write(stdout)
        with open(temp_err_path, 'w') as f:
            f.write(stderr)
        
        if exit_code == 0:
            response = stdout
            
            # Check if response is empty
            if not response:
                log_error(f"Empty response from model {model}", context)
                cleanup_temp_files([temp_out_path, temp_err_path])
                return None
            
            # Save to history
            save_to_history(prompt, response, model)
            
            cleanup_temp_files([temp_out_path, temp_err_path])
            return response
        else:
            if exit_code == 124:
                log_error(f"Request timed out after {AI_WOFI_TIMEOUT}s", context)
            else:
                error_msg = f"Exit code: {exit_code}"
                if stderr:
                    error_msg = f"{error_msg}\nError: {stderr}"
                log_error(error_msg, context)
            
            cleanup_temp_files([temp_out_path, temp_err_path])
            return None
    
    except Exception as e:
        log_error(f"Exception in ai_request: {str(e)}", context)
        cleanup_temp_files([temp_out_path, temp_err_path])
        return None

# Clean up temporary files
def cleanup_temp_files(files):
    """Remove temporary files"""
    for file in files:
        try:
            os.unlink(file)
        except (OSError, PermissionError):
            pass

# Get multiline input using editor
def get_multiline_input(prompt_text):
    """Get multiline input using editor"""
    temp_file = tempfile.NamedTemporaryFile(prefix=f"wofi-ai-{os.getpid()}-input.", delete=False).name
    
    # Pre-populate with template
    with open(temp_file, 'w') as f:
        f.write(f"# {prompt_text}\n")
        f.write("# Lines starting with # will be ignored\n")
        f.write("# Save and exit when done\n\n")
    
    # Open in preferred editor
    editor = os.environ.get('EDITOR', None)
    
    if editor and shutil.which(editor):
        subprocess.run([editor, temp_file], check=False)
    elif shutil.which('nano'):
        terminal = AI_WOFI_TERMINAL or "foot"
        if shutil.which(terminal):
            subprocess.run([terminal, "-e", "nano", temp_file], check=False)
        else:
            os.unlink(temp_file)
            return ""
    else:
        os.unlink(temp_file)
        return ""
    
    # Read content (skip comments and empty lines)
    with open(temp_file, 'r') as f:
        lines = f.readlines()
    
    os.unlink(temp_file)
    return "\n".join([line for line in lines if not line.strip().startswith('#') and line.strip()])

# Confirm before sending clipboard content
def confirm_clipboard_send(content):
    """Confirm before sending clipboard content"""
    preview = content[:100]
    if len(content) > 100:
        preview += "..."
    
    options = ["Yes, send it", "No, cancel"]
    confirm = run_wofi(f"Send clipboard to AI?", options)
    
    return confirm == "Yes, send it"

# Handle response with follow-up options
def handle_response(response, context):
    """Handle response with follow-up options"""
    # Show truncated response in notification (no automatic clipboard copy)
    display_response = response
    if len(response) > 200:
        display_response = response[:197] + "..."
    
    try:
        subprocess.run(["notify-send", "AI Response", display_response, "-t", "10000"], check=False)
    except Exception:
        pass
    
    # Offer follow-up actions
    options = ["Copy to clipboard", "Save to file", "Refine this response", "Ask follow-up question", "Done"]
    action = run_wofi("What would you like to do?", options)
    
    if not action or action == "Done":
        return
    
    if action == "Copy to clipboard":
        try:
            stdout, stderr, exit_code = execute_command(["wl-copy"], response)
            subprocess.run(["notify-send", "Copied", "Response copied to clipboard", "-t", "3000"], check=False)
        except Exception as e:
            log_error(f"Error copying to clipboard: {e}", "handle_response")
    
    elif action == "Save to file":
        filename = run_wofi("Filename:", [""])
        if filename:
            # Add appropriate extension if not provided
            if "." not in filename:
                filename += ".txt"
            
            try:
                with open(f"{CACHE_DIR}/{filename}", 'w') as f:
                    f.write(response)
                subprocess.run(["notify-send", "Saved", f"Response saved to:\n{CACHE_DIR}/{filename}", "-t", "5000"], 
                              check=False)
            except Exception as e:
                log_error(f"Error saving file: {e}", "handle_response")
    
    elif action == "Refine this response":
        refinement = run_wofi("How should I refine this?", [""])
        if refinement:
            new_prompt = f"Refine this response: {refinement}\n\nOriginal response: {response}"
            mode_quick_query_with_prompt(new_prompt)
    
    elif action == "Ask follow-up question":
        follow_up = run_wofi("Follow-up question:", [""])
        if follow_up:
            new_prompt = f"Context: {response}\n\nFollow-up question: {follow_up}"
            mode_quick_query_with_prompt(new_prompt)

# Quick query mode
def mode_quick_query():
    """Quick query mode"""
    prompt = ""
    
    # Try to get clipboard content
    stdout, stderr, exit_code = execute_command(["wl-paste"])
    clipboard_content = stdout if exit_code == 0 else ""
    
    # Check if clipboard has content
    if clipboard_content:
        # Truncate for preview
        preview = clipboard_content[:100]
        if len(clipboard_content) > 100:
            preview += "..."
        
        # Offer option to use clipboard with ability to directly type a query
        options = ["Use clipboard content", "Enter new prompt"]
        action = run_wofi(f"Clipboard has content: {preview}", options, allow_custom_input=True)
        
        if not action:
            return
        
        if action == "Use clipboard content":
            prompt = run_wofi("Edit prompt:", [clipboard_content])
        elif action == "Enter new prompt":
            prompt = run_wofi("Ask AI", [""])
        else:
            # User typed something directly
            prompt = action
    else:
        # No clipboard content, just ask for prompt
        prompt = run_wofi("Ask AI", [""])
    
    if not prompt:
        return
    
    mode_quick_query_with_prompt(prompt)

def mode_quick_query_with_prompt(prompt):
    """Quick query with provided prompt"""
    response = ai_request(prompt, AI_WOFI_MODEL, "", "quick_query")
    if response:
        handle_response(response, "quick_query")

# Rewrite selection mode
def mode_rewrite():
    """Rewrite text mode"""
    # Get clipboard content
    stdout, stderr, exit_code = execute_command(["wl-paste"])
    content = stdout if exit_code == 0 else ""
    
    if not content:
        subprocess.run(["notify-send", "No Content", "Clipboard is empty. Copy some text first.", "-u", "normal"], 
                      check=False)
        return
    
    # Confirm before sending
    if not confirm_clipboard_send(content):
        return
    
    # Show rewrite options
    options = [
        "Improve grammar and clarity",
        "Make more concise", 
        "Make more formal", 
        "Make more casual",
        "Fix spelling and grammar",
        "Translate to Spanish",
        "Translate to French",
        "Translate to German",
        "Custom instruction..."
    ]
    
    action = run_wofi("Rewrite as", options)
    
    if not action:
        return
    
    if action == "Custom instruction...":
        instruction = run_wofi("Enter instruction", [""])
        if not instruction:
            return
    else:
        instruction = action
    
    prompt = f"{instruction} the following text, return only the rewritten text without explanation:\n\n{content}"
    response = ai_request(prompt, AI_WOFI_MODEL, "", "rewrite_text")
    
    if response:
        handle_response(response, "rewrite_text")

# Command generation mode
def mode_command():
    """Generate shell commands based on description"""
    request = run_wofi("What command do you need?", [""])
    if not request:
        return
    
    # Use shell role if available
    roles = get_roles_cached()
    context = "command_generation"
    
    if "shell" in roles:
        response = ai_request(request, AI_WOFI_MODEL, "shell", context)
    else:
        prompt = "Generate 5 different shell commands for: " + request + ". Output only the commands, one per line, no explanations, no markdown, no formatting."
        response = ai_request(prompt, AI_WOFI_MODEL, "", context)
    
    if response:
        # Clean up response
        response = re.sub(r'```.*?```', '', response, flags=re.DOTALL)
        commands = [cmd.strip() for cmd in response.split('\n') if cmd.strip()]
        
        # Let user select a command
        selected_cmd = run_wofi("Select command", commands)
        
        if selected_cmd:
            handle_command(selected_cmd)

# Handle selected command
def handle_command(cmd):
    """Handle selected command - copy, execute, or edit first"""
    options = ["Execute", "Copy to clipboard", "Edit first"]
    action = run_wofi("Action", options)
    
    if not action:
        return
    
    if action == "Copy to clipboard":
        stdout, stderr, exit_code = execute_command(["wl-copy"], cmd)
        subprocess.run(["notify-send", "Copied", cmd], check=False)
    
    elif action == "Execute":
        subprocess.run(["notify-send", "Executing", cmd], check=False)
        
        # Execute in shell
        try:
            process = subprocess.Popen(cmd, shell=True)
            # Don't wait for process to complete in case it's a long-running command
        except Exception as e:
            log_error(f"Command execution failed: {cmd}, Error: {str(e)}", "command_execute")
    
    elif action == "Edit first":
        edited_cmd = run_wofi("Edit command", [cmd])
        
        if edited_cmd:
            # Offer to copy or execute the edited command
            options = ["Execute", "Copy to clipboard"]
            edited_action = run_wofi("Action for edited command", options)
            
            if edited_action == "Execute":
                subprocess.run(["notify-send", "Executing", edited_cmd], check=False)
                try:
                    process = subprocess.Popen(edited_cmd, shell=True)
                except Exception as e:
                    log_error(f"Command execution failed: {edited_cmd}, Error: {str(e)}", "command_execute")
            
            elif edited_action == "Copy to clipboard":
                stdout, stderr, exit_code = execute_command(["wl-copy"], edited_cmd)
                subprocess.run(["notify-send", "Copied", edited_cmd], check=False)

# Code helper mode
def mode_code():
    """Code helper mode for analyzing and transforming code"""
    # Get clipboard content
    stdout, stderr, exit_code = execute_command(["wl-paste"])
    code = stdout if exit_code == 0 else ""
    
    if code:
        options = [
            "Explain this code",
            "Find bugs",
            "Optimize",
            "Add comments",
            "Convert to different language",
            "Write tests",
            "Generate documentation",
            "Use new code...",
            "Paste multiline code..."
        ]
        action = run_wofi("Code action", options)
    else:
        action = "Use new code..."
    
    if not action:
        return
    
    if action == "Use new code...":
        code = run_wofi("Paste your code", [""])
        if not code:
            return
        
        options = [
            "Explain this code",
            "Find bugs",
            "Optimize",
            "Add comments",
            "Convert to different language",
            "Write tests",
            "Generate documentation"
        ]
        action = run_wofi("Code action", options)
        
        if not action:
            return
    
    elif action == "Paste multiline code...":
        code = get_multiline_input("Paste your code")
        if not code:
            return
        
        options = [
            "Explain this code",
            "Find bugs",
            "Optimize",
            "Add comments",
            "Convert to different language",
            "Write tests",
            "Generate documentation"
        ]
        action = run_wofi("Code action", options)
        
        if not action:
            return
    
    context = f"code_helper_{action.replace(' ', '_')}"
    model = get_model_for_mode("code")
    
    if action == "Explain this code":
        prompt = f"Explain what this code does in simple terms:\n\n{code}"
    
    elif action == "Find bugs":
        prompt = f"Find potential bugs or issues in this code:\n\n{code}"
    
    elif action == "Optimize":
        prompt = f"Optimize this code for better performance:\n\n{code}"
    
    elif action == "Add comments":
        prompt = f"Add helpful comments to this code:\n\n{code}"
    
    elif action == "Convert to different language":
        target_lang = run_wofi("Target language", [""])
        if not target_lang:
            return
        prompt = f"Convert this code to {target_lang}:\n\n{code}"
    
    elif action == "Write tests":
        prompt = f"Write comprehensive unit tests for this code:\n\n{code}"
    
    elif action == "Generate documentation":
        prompt = f"Generate detailed documentation for this code:\n\n{code}"
    
    else:
        return
    
    # Get roles
    roles = get_roles_cached()
    
    if "code" in roles:
        response = ai_request(prompt, model, "code", context)
    else:
        response = ai_request(prompt, model, "", context)
    
    if response:
        # For code responses, save to temp file and open in editor
        timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        temp_file = f"{CACHE_DIR}/code_{action.replace(' ', '_')}_{timestamp}.md"
        
        try:
            with open(temp_file, 'w') as f:
                f.write(response)
            
            # Open in editor and offer clipboard option
            subprocess.run(["notify-send", "Code Response", f"Opening in editor: {temp_file}", "-t", "3000"], check=False)
            
            # Try to open in preferred editor
            editor = os.environ.get('EDITOR', '')
            
            if editor and shutil.which(editor):
                subprocess.run([editor, temp_file], check=False)
            elif shutil.which('code'):
                subprocess.run(['code', temp_file], check=False)
            elif shutil.which('vim'):
                terminal = AI_WOFI_TERMINAL or "foot"
                subprocess.run([terminal, "-e", "vim", temp_file], check=False)
            
            # After editor, offer to copy
            options = ["Copy to clipboard", "Done"]
            post_action = run_wofi("Would you like to copy the response?", options)
            
            if post_action == "Copy to clipboard":
                stdout, stderr, exit_code = execute_command(["wl-copy"], response)
                subprocess.run(["notify-send", "Copied", "Code response copied to clipboard", "-t", "3000"], check=False)
        
        except Exception as e:
            log_error(f"Error handling code response: {str(e)}", context)

# Start chat mode
def mode_chat():
    """Open AIChat in a terminal session"""
    # Get available sessions
    stdout, stderr, exit_code = execute_command(["aichat", "--list-sessions"])
    sessions = stdout.split('\n') if exit_code == 0 and stdout else []
    
    options = ["New session"] + sessions if sessions else ["New session"]
    session_action = run_wofi("Select session", options)
    
    if not session_action:
        return
    
    model = get_model_for_mode("chat")
    cmd = f"aichat --model {model}"
    
    if session_action != "New session":
        cmd += f" --session \"{session_action}\""
    
    # Start chat in terminal
    terminal = AI_WOFI_TERMINAL or "foot"
    
    if shutil.which(terminal):
        subprocess.Popen([terminal, "-e", "bash", "-c", f"{cmd} || (echo 'aichat failed. Press enter to exit...'; read)"], 
                        start_new_session=True)
    else:
        log_error(f"No terminal emulator found (AI_WOFI_TERMINAL={AI_WOFI_TERMINAL or 'not set'})", "mode_chat")

# Open Aider in terminal
def mode_aider():
    """Open Aider in a terminal window"""
    if not shutil.which('aider'):
        subprocess.run(["notify-send", "Aider Not Found", "Please install aider first.", "-u", "critical"], check=False)
        return
    
    terminal = AI_WOFI_TERMINAL or "foot"
    
    if shutil.which(terminal):
        subprocess.Popen([terminal, "-e", "bash", "-c", "aider || (echo 'aider failed. Press enter to exit...'; read)"], 
                        start_new_session=True)
    else:
        log_error(f"No terminal emulator found (AI_WOFI_TERMINAL={AI_WOFI_TERMINAL or 'not set'})", "mode_aider")

# Goose mode
def mode_goose():
    """Open Goose in a terminal window"""
    if not shutil.which('goose'):
        subprocess.run(["notify-send", "Goose Not Found", "Please install goose first.", "-u", "critical"], check=False)
        return
    
    terminal = AI_WOFI_TERMINAL or "foot"
    
    if shutil.which(terminal):
        subprocess.Popen([terminal, "-e", "bash", "-c", "goose || (echo 'goose failed. Press enter to exit...'; read)"], 
                        start_new_session=True)
    else:
        log_error(f"No terminal emulator found (AI_WOFI_TERMINAL={AI_WOFI_TERMINAL or 'not set'})", "mode_goose")

# Open Ollama in terminal
def mode_ollama():
    """Open Ollama with a selected model in a terminal"""
    # Double check that ollama is installed
    if not shutil.which('ollama'):
        subprocess.run(["notify-send", "Ollama Not Found", "Please install Ollama first.", "-u", "critical"], check=False)
        return
    
    # Get available models
    stdout, stderr, exit_code = execute_command(["ollama", "list"])
    
    if exit_code != 0 or not stdout:
        subprocess.run(["notify-send", "Ollama Error", "No models available. Please pull some Ollama models first.", "-u", "critical"], 
                      check=False)
        return
    
    # Parse the model list
    models = []
    for line in stdout.split('\n')[1:]:  # Skip header
        if line.strip():
            model_name = line.split()[0]
            if model_name:
                models.append(model_name)
    
    if not models:
        subprocess.run(["notify-send", "Ollama Error", "No models available. Please pull some Ollama models first.", "-u", "critical"], 
                      check=False)
        return
    
    # Show model selection
    selected_model = run_wofi("Select Ollama model", models)
    
    if not selected_model:
        return
    
    # Run selected model
    cmd = f"ollama run \"{selected_model}\""
    
    terminal = AI_WOFI_TERMINAL or "foot"
    
    if shutil.which(terminal):
        subprocess.Popen([terminal, "-e", "bash", "-c", f"{cmd} || (echo 'ollama failed. Press enter to exit...'; read)"], 
                        start_new_session=True)
    else:
        log_error(f"No terminal emulator found (AI_WOFI_TERMINAL={AI_WOFI_TERMINAL or 'not set'})", "mode_ollama")

# Roles mode
def mode_roles():
    """Use a specific role from aichat"""
    roles = get_roles_cached()
    
    if not roles:
        subprocess.run(["notify-send", "No Roles", "No roles configured in aichat\nAdd roles to ~/.config/aichat/config.yaml", "-u", "normal"], 
                      check=False)
        return
    
    selected_role = run_wofi("Select role", roles)
    if not selected_role:
        return
    
    prompt = run_wofi(f"Ask {selected_role}", [""])
    if not prompt:
        return
    
    response = ai_request(prompt, AI_WOFI_MODEL, selected_role, f"role_{selected_role}")
    
    if response:
        handle_response(response, f"role_{selected_role}")

# History mode
def mode_history():
    """View and interact with history"""
    # Check if history file exists and isn't empty
    if not os.path.exists(HISTORY_FILE):
        subprocess.run(["notify-send", "No History", f"No history file found at {HISTORY_FILE}", "-u", "normal"], 
                      check=False)
        return
    
    if os.path.getsize(HISTORY_FILE) == 0:
        subprocess.run(["notify-send", "No History", "History file exists but is empty", "-u", "normal"], 
                      check=False)
        return
    
    # Create temporary files
    display_file = tempfile.NamedTemporaryFile(prefix=f"wofi-ai-{os.getpid()}-display.", delete=False).name
    temp_file = tempfile.NamedTemporaryFile(prefix=f"wofi-ai-{os.getpid()}-content.", delete=False).name
    
    # Copy the whole history file for reference
    shutil.copy(HISTORY_FILE, temp_file)
    
    try:
        # Read history file
        with open(HISTORY_FILE, 'r') as f:
            content = f.read()
        
        # Extract timestamps and responses (simplified approach)
        timestamp_matches = re.findall(r'"timestamp": "([^"]*)"', content)
        response_matches = re.findall(r'"response": "([^"]*)"', content)
        prompt_matches = re.findall(r'"prompt": "([^"]*)"', content)
        
        # Format and show entries
        display_entries = []
        
        for i, (timestamp, response) in enumerate(zip(timestamp_matches, response_matches), 1):
            try:
                # Format date
                dt = datetime.datetime.fromisoformat(timestamp)
                formatted_date = f"{dt.month:02d}/{dt.day:02d} {dt.hour:02d}:{dt.minute:02d}"
                
                # Truncate response
                truncated_response = response[:50] + "..." if len(response) > 50 else response
                
                # Create display entry
                display_entries.append(f"[{i}] {formatted_date} → {truncated_response}")
            except Exception as e:
                log_error(f"Error formatting history entry: {str(e)}", "mode_history")
        
        # Write to display file
        with open(display_file, 'w') as f:
            f.write('\n'.join(display_entries))
        
        # Show menu with the entries
        if not display_entries:
            subprocess.run(["notify-send", "Error", "Could not parse any entries from history file", "-u", "critical"], 
                          check=False)
            cleanup_temp_files([display_file, temp_file])
            return
        
        subprocess.run(["notify-send", "History", f"Found {len(display_entries)} entries", "-t", "1000"], 
                      check=False)
        
        selected = run_wofi("History", display_entries)
        
        if not selected:
            cleanup_temp_files([display_file, temp_file])
            return
        
        # Extract entry number from selection
        match = re.search(r'^\[(\d+)\]', selected)
        if not match:
            cleanup_temp_files([display_file, temp_file])
            return
        
        entry_num = int(match.group(1))
        
        # Get response and prompt
        if 1 <= entry_num <= len(response_matches):
            response = response_matches[entry_num-1]
            prompt = prompt_matches[entry_num-1] if entry_num <= len(prompt_matches) else ""
            
            # Offer options for historical response
            options = ["Copy to clipboard", "Save to file", "Modify and reuse prompt", "Done"]
            action = run_wofi("What would you like to do with this response?", options)
            
            if not action or action == "Done":
                cleanup_temp_files([display_file, temp_file])
                return
            
            if action == "Copy to clipboard":
                stdout, stderr, exit_code = execute_command(["wl-copy"], response)
                subprocess.run(["notify-send", "Copied", "Historical response copied to clipboard", "-t", "3000"], 
                              check=False)
            
            elif action == "Save to file":
                filename = run_wofi("Filename:", [""])
                if filename:
                    if "." not in filename:
                        filename += ".txt"
                    
                    with open(f"{CACHE_DIR}/{filename}", 'w') as f:
                        f.write(response)
                    
                    subprocess.run(["notify-send", "Saved", f"Response saved to:\n{CACHE_DIR}/{filename}", "-t", "5000"], 
                                  check=False)
            
            elif action == "Modify and reuse prompt":
                if prompt:
                    new_prompt = run_wofi("Edit prompt:", [prompt])
                    
                    if new_prompt:
                        mode_quick_query_with_prompt(new_prompt)
                else:
                    subprocess.run(["notify-send", "Error", "Could not extract original prompt", "-u", "critical"], 
                                  check=False)
        
        cleanup_temp_files([display_file, temp_file])
    
    except Exception as e:
        log_error(f"Error in history mode: {str(e)}", "mode_history")
        cleanup_temp_files([display_file, temp_file])

# Settings mode
def mode_settings():
    """Settings management"""
    global AI_WOFI_MODEL, AI_WOFI_CODE_MODEL, AI_WOFI_CHAT_MODEL, AI_WOFI_TIMEOUT
    
    options = [
        f"Select default model (current: {AI_WOFI_MODEL})",
        f"Select code model (current: {AI_WOFI_CODE_MODEL})",
        f"Select chat model (current: {AI_WOFI_CHAT_MODEL})",
        f"Set timeout (current: {AI_WOFI_TIMEOUT}s)",
        "Manage aichat config",
        "View error log",
        "Clear error log",
        "Clear cache",
        "View settings file"
    ]
    
    action = run_wofi("Settings", options)
    
    if not action:
        return
    
    if "Select default model" in action:
        models = get_models_cached()
        if not models:
            subprocess.run(["notify-send", "No Models", "Could not retrieve models", "-u", "critical"], check=False)
            return
        
        model = run_wofi("Select model", models)
        if model:
            try:
                with open(f"{CONFIG_DIR}/config", 'w') as f:
                    f.write(f'AI_WOFI_MODEL="{model}"\n')
                AI_WOFI_MODEL = model
                subprocess.run(["notify-send", "Settings", f"Default model changed to {model}\nRestart script to apply from settings file"], 
                              check=False)
            except Exception as e:
                log_error(f"Error saving model setting: {str(e)}", "mode_settings")
    
    elif "Select code model" in action:
        models = get_models_cached()
        if not models:
            subprocess.run(["notify-send", "No Models", "Could not retrieve models", "-u", "critical"], check=False)
            return
        
        model = run_wofi("Select code model", models)
        if model:
            try:
                # Append to config file
                with open(f"{CONFIG_DIR}/config", 'a') as f:
                    f.write(f'AI_WOFI_CODE_MODEL="{model}"\n')
                AI_WOFI_CODE_MODEL = model
                subprocess.run(["notify-send", "Settings", f"Code model changed to {model}\nRestart script to apply from settings file"], 
                              check=False)
            except Exception as e:
                log_error(f"Error saving code model setting: {str(e)}", "mode_settings")
    
    elif "Select chat model" in action:
        models = get_models_cached()
        if not models:
            subprocess.run(["notify-send", "No Models", "Could not retrieve models", "-u", "critical"], check=False)
            return
        
        model = run_wofi("Select chat model", models)
        if model:
            try:
                # Append to config file
                with open(f"{CONFIG_DIR}/config", 'a') as f:
                    f.write(f'AI_WOFI_CHAT_MODEL="{model}"\n')
                AI_WOFI_CHAT_MODEL = model
                subprocess.run(["notify-send", "Settings", f"Chat model changed to {model}\nRestart script to apply from settings file"], 
                              check=False)
            except Exception as e:
                log_error(f"Error saving chat model setting: {str(e)}", "mode_settings")
    
    elif "Set timeout" in action:
        timeout_options = ["10", "20", "30", "60", "120"]
        timeout = run_wofi("Timeout (seconds)", timeout_options)
        if timeout:
            try:
                # Append to config file
                with open(f"{CONFIG_DIR}/config", 'a') as f:
                    f.write(f'AI_WOFI_TIMEOUT="{timeout}"\n')
                AI_WOFI_TIMEOUT = int(timeout)
                subprocess.run(["notify-send", "Settings", f"Timeout set to {timeout}s\nRestart script to apply from settings file"], 
                              check=False)
            except Exception as e:
                log_error(f"Error saving timeout setting: {str(e)}", "mode_settings")
    
    elif action == "Manage aichat config":
        subprocess.run(["notify-send", "aichat config", "Run 'aichat --edit-config' in terminal\nOr edit: ~/.config/aichat/config.yaml"], 
                      check=False)
    
    elif action == "View error log":
        if os.path.exists(LOG_FILE):
            try:
                with open(LOG_FILE, 'r') as f:
                    all_lines = f.readlines()
                    log_lines = all_lines[-50:] if len(all_lines) > 50 else all_lines
                run_wofi("Error Log (last 50 lines)", log_lines, multiline=True)
            except Exception as e:
                log_error(f"Error reading log file: {str(e)}", "mode_settings")
        else:
            subprocess.run(["notify-send", "No errors", "No error log found"], check=False)
    
    elif action == "Clear error log":
        try:
            with open(LOG_FILE, 'w') as f:
                pass
            subprocess.run(["notify-send", "Log cleared", "Error log has been cleared"], check=False)
        except Exception as e:
            log_error(f"Error clearing log file: {str(e)}", "mode_settings")
    
    elif action == "Clear cache":
        try:
            for cache_file in [MODELS_CACHE, ROLES_CACHE]:
                if os.path.exists(cache_file):
                    os.unlink(cache_file)
            cleanup_old_files()
            subprocess.run(["notify-send", "Cache cleared", "All cache files have been cleared"], check=False)
        except Exception as e:
            log_error(f"Error clearing cache: {str(e)}", "mode_settings")
    
    elif action == "View settings file":
        settings_locations = (
            "Checked in order:\n"
            f"1. {SCRIPT_DIR}/ai-wofi-settings\n"
            f"2. {CONFIG_DIR}/ai-wofi-settings\n"
            f"3. ~/.ai-wofi-settings\n\n"
            "Create one of these files with:\n"
            "AI_WOFI_DEFAULT_MODEL=\"your-model\"\n"
            "AI_WOFI_CODE_MODEL=\"your-code-model\"\n"
            "AI_WOFI_CHAT_MODEL=\"your-chat-model\"\n"
            "AI_WOFI_TIMEOUT=\"30\"\n"
            "AI_WOFI_TERMINAL=\"your-terminal\""
        )
        subprocess.run(["notify-send", "Settings File Locations", settings_locations, "-t", "10000"], check=False)
    
    elif action == "About":
        info = (
            f"wofi-ai v{VERSION}\n\n"
            f"Models cache: {MODELS_CACHE}\n"
            f"Roles cache: {ROLES_CACHE}\n"
            f"History: {HISTORY_FILE}\n"
            f"Error log: {LOG_FILE}\n\n"
            f"Using: {shutil.which('aichat') or 'aichat'}\n\n"
            f"Settings file locations checked:\n"
            f"{SCRIPT_DIR}/ai-wofi-settings\n"
            f"{CONFIG_DIR}/ai-wofi-settings\n"
            f"~/.ai-wofi-settings"
        )
        run_wofi("About wofi-ai", [info], multiline=True)

# Initialize
def init():
    """Initialize the application"""
    global AI_WOFI_MODEL, AI_WOFI_CODE_MODEL, AI_WOFI_CHAT_MODEL, AI_WOFI_TIMEOUT, AI_WOFI_TERMINAL
    
    init_directories()
    
    # Check dependencies on first run
    if not check_dependencies():
        sys.exit(1)
    
    # Load config and settings
    load_config()
    load_settings()
    
    # Check AI backend
    if not check_aichat():
        sys.exit(1)
    
    # Validate and set fallback model
    if not AI_WOFI_MODEL or not validate_model(AI_WOFI_MODEL):
        fallback = get_first_available_model()
        if fallback:
            subprocess.run(["notify-send", "Model Not Found", f"Using fallback model: {fallback}", "-u", "warning"],
                          check=False)
            AI_WOFI_MODEL = fallback
        else:
            log_error("No models available", "init")
            sys.exit(1)
    
    # Clean up old files periodically
    cleanup_old_files()

# Main menu
def main():
    """Show main menu and handle selection"""
    # Build menu dynamically based on available tools
    menu_items = [
        "💬 Quick Query",
        "✏️  Rewrite Text",
        "🖥️  Generate Command",
        "🧩 Code Helper",
        "🎭 Use Role",
        "💭 Open AIChat",
        "📜 History",
        "⚙️ Settings"
    ]
    
    # Only add Aider if it's available
    if shutil.which('aider'):
        menu_items.append("🤖 Open Aider")
    
    # Only add Goose if it's available
    if shutil.which('goose'):
        menu_items.append("🦆 Open Goose")
    
    # Only add Ollama if it's available
    if shutil.which('ollama'):
        menu_items.append("🦙 Open Ollama")
    
    selected = run_wofi("AI Assistant", menu_items)
    
    if not selected:
        return
    
    if selected == "💬 Quick Query":
        mode_quick_query()
    elif selected == "✏️  Rewrite Text":
        mode_rewrite()
    elif selected == "🖥️  Generate Command":
        mode_command()
    elif selected == "🧩 Code Helper":
        mode_code()
    elif selected == "🎭 Use Role":
        mode_roles()
    elif selected == "💭 Open AIChat":
        mode_chat()
    elif selected == "🤖 Open Aider":
        mode_aider()
    elif selected == "🦆 Open Goose":
        mode_goose()
    elif selected == "🦙 Open Ollama":
        mode_ollama()
    elif selected == "📜 History":
        mode_history()
    elif selected == "⚙️ Settings":
        mode_settings()

if __name__ == "__main__":
    if len(sys.argv) > 1:
        command = sys.argv[1]
        
        init()
        
        if command == "query":
            mode_quick_query()
        elif command == "rewrite":
            mode_rewrite()
        elif command == "command":
            mode_command()
        elif command == "code":
            mode_code()
        elif command == "roles":
            mode_roles()
        elif command == "chat":
            mode_chat()
        elif command == "goose":
            if shutil.which('goose'):
                mode_goose()
            else:
                subprocess.run(["notify-send", "Goose Not Found", "Please install goose first.", "-u", "critical"],
                              check=False)
        elif command == "history":
            mode_history()
        elif command == "settings":
            mode_settings()
        elif command == "log":
            if os.path.exists(LOG_FILE):
                with open(LOG_FILE, 'r') as f:
                    print(f.read())
            else:
                print("No error log found")
        elif command == "version":
            print(f"wofi-ai version {VERSION}")
        else:
            main()
    else:
        init()
        main()