#!/usr/bin/env python3
"""
LiteLLM integration for Espanso
Allows using various LLM providers through LiteLLM
"""

import argparse
import json
import os
import sys
import yaml
from pathlib import Path
from typing import Dict, Any, Optional

try:
    from litellm import completion
except ImportError:
    print("Error: litellm package not found. Please install it with 'pip install litellm'")
    sys.exit(1)

CONFIG_FILE = os.path.expanduser("~/.config/espanso/litellm_config.yaml")

def load_config() -> Dict[str, Any]:
    """Load configuration from the config file"""
    config_path = Path(CONFIG_FILE)
    if not config_path.exists():
        # Create default config if it doesn't exist
        default_config = {
            "default_provider": "ollama",
            "default_model": "llama3:latest",
            "providers": {
                "ollama": {
                    "api_base": "http://localhost:11434",
                    "models": {
                        "default": "llama3:latest"
                    }
                },
                "openai": {
                    "api_key": "",
                    "models": {
                        "default": "gpt-3.5-turbo"
                    }
                },
                "openrouter": {
                    "api_key": "",
                    "models": {
                        "default": "anthropic/claude-3-sonnet"
                    }
                },
                "nano-gpt": {
                    "api_base": "https://nano-gpt.com",
                    "api_key": "",
                    "models": {
                        "default": "TEE/llama-3.3-70b-instruct"
                    }
                },
                "claude": {
                    "api_base": "https://api.anthropic.com/v1",
                    "api_key": "",
                    "models": {
                        "default": "claude-3-sonnet-20240229"
                    }
                },
                "perplexity": {
                    "api_base": "https://api.perplexity.ai",
                    "api_key": "",
                    "models": {
                        "default": "sonar-medium-online"
                    }
                }
            },
            "roles": {
                "default": "You are a helpful assistant.",
                "spanish": "You are a helpful translator. Translate the following text to Spanish:",
                "french": "You are a helpful translator. Translate the following text to French:",
                "cli": "You are a CLI command generator. Generate a bash command based on this description:",
                "emoji": "Convert the following text description into appropriate emojis only. Do not include any explanation:"
            },
            "temperature": 0.7,
            "max_tokens": 1000
        }
        
        # Create parent directories if they don't exist
        config_path.parent.mkdir(parents=True, exist_ok=True)
        
        with open(config_path, 'w') as f:
            yaml.dump(default_config, f, default_flow_style=False)
        
        return default_config
    
    with open(config_path, 'r') as f:
        return yaml.safe_load(f)

def get_provider_config(config: Dict[str, Any], provider_name: Optional[str] = None) -> Dict[str, Any]:
    """Get configuration for a specific provider or the default provider"""
    if not provider_name:
        provider_name = config.get("default_provider", "ollama")
    
    provider_config = config.get("providers", {}).get(provider_name, {})
    return provider_config

def get_model_for_provider(config: Dict[str, Any], provider_name: Optional[str] = None, 
                          model_name: Optional[str] = None) -> str:
    """Get the model name for a specific provider"""
    provider_config = get_provider_config(config, provider_name)
    
    if not model_name:
        model_name = "default"
    
    model = provider_config.get("models", {}).get(model_name)
    if not model:
        # If specific model not found, use the default for the provider
        model = provider_config.get("models", {}).get("default")
    
    # If still no model found, use the global default
    if not model:
        model = config.get("default_model", "llama3:latest")
    
    return model

def get_role_prompt(config: Dict[str, Any], role: str) -> str:
    """Get the prompt for a specific role"""
    return config.get("roles", {}).get(role, config.get("roles", {}).get("default", "You are a helpful assistant."))

def query_llm(prompt: str, config: Dict[str, Any], role: str = "default", 
             provider: Optional[str] = None, model: Optional[str] = None) -> str:
    """Query the LLM with the given prompt and configuration"""
    # Load the provider config
    provider_name = provider or config.get("default_provider", "ollama")
    provider_config = get_provider_config(config, provider_name)
    
    # Get the model
    model_name = get_model_for_provider(config, provider_name, model)
    
    # Get the role prompt
    role_prompt = get_role_prompt(config, role)
    
    # Prepare API parameters
    api_params = {}
    
    # Set API base URL if provider has one
    if "api_base" in provider_config:
        api_params["api_base"] = provider_config.get("api_base")
    
    # Set API key if provider requires one
    if "api_key" in provider_config:
        api_params["api_key"] = provider_config.get("api_key", "")
    
    # Provider-specific configurations
    if provider_name == "nano-gpt":
        # nano-gpt is OpenAI-compatible but needs specific settings
        api_params["api_type"] = "openai"
    elif provider_name == "claude":
        # Claude specific settings
        api_params["api_type"] = "anthropic"
    elif provider_name == "perplexity":
        # Perplexity specific settings if needed
        api_params["api_type"] = "openai"
    
    # Prepare messages
    messages = [
        {"role": "system", "content": role_prompt},
        {"role": "user", "content": prompt}
    ]
    
    try:
        response = completion(
            model=model_name,
            messages=messages,
            temperature=config.get("temperature", 0.7),
            max_tokens=config.get("max_tokens", 1000),
            **api_params
        )
        
        # Extract the response content based on the provider
        if hasattr(response, 'choices') and len(response.choices) > 0:
            # OpenAI style response
            content = response.choices[0].message.content
        else:
            # Try to extract content from the response
            content = str(response)
            
        return content.strip()
    except Exception as e:
        return f"Error: {str(e)}"

def main():
    """Main entry point"""
    parser = argparse.ArgumentParser(description='LiteLLM Expander for Espanso')
    parser.add_argument('--prompt', type=str, help='The prompt to send to the LLM')
    parser.add_argument('--role', type=str, default='default', help='The role to use for the prompt')
    parser.add_argument('--provider', type=str, help='The provider to use')
    parser.add_argument('--model', type=str, help='The model to use')
    
    args = parser.parse_args()
    
    if not args.prompt:
        return "Error: No prompt provided"
    
    config = load_config()
    response = query_llm(args.prompt, config, args.role, args.provider, args.model)
    
    print(response)

if __name__ == "__main__":
    main()