{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  # Import NUR to access packages
  nur = import inputs.nur {
    nurpkgs = pkgs;
    pkgs = pkgs;
  };
in
{

  home.packages = [
    # Add Charm package from NUR
    nur.repos.charmbracelet.crush
    pkgs.gpt4all
    pkgs.aichat
    pkgs.aider-chat
    pkgs.jq
    pkgs.openai-whisper
    pkgs.goose-cli
    pkgs.koboldcpp
    pkgs.plandex
    pkgs.open-interpreter
    pkgs.librechat
    pkgs.opencode
    pkgs.mods
    
    # LSP servers for Crush
    pkgs.python311Packages.python-lsp-server
    pkgs.nodePackages.bash-language-server
    pkgs.gopls
    pkgs.nodePackages.typescript-language-server
    pkgs.nodePackages.vscode-langservers-extracted
    pkgs.rust-analyzer
  ];

  home.file.".config/crush/crush.json".text = ''
    {
      "$schema": "https://charm.land/crush.json",
      "providers": {
        "nanogpt": {
          "type": "openai-compat",
          "base_url": "https://nano-gpt.com/api/v1",
          "api_key": "$OPENAI_API_KEY",
          "models": [
            {
              "id": "z-ai/glm-4.6",
              "name": "z-ai/glm-4.6",
              "cost_per_1m_in": 0.38,
              "cost_per_1m_out": 1.42,
              "cost_per_1m_in_cached": 0.38,
              "cost_per_1m_out_cached": 1.42,
              "context_window": 200000,
              "default_max_tokens": 8192
            },
            {
              "id": "z-ai/glm-4.6:thinking",
              "name": "z-ai/glm-4.6:thinking",
              "cost_per_1m_in": 0.38,
              "cost_per_1m_out": 1.42,
              "cost_per_1m_in_cached": 0.38,
              "cost_per_1m_out_cached": 1.42,
              "context_window": 200000,
              "default_max_tokens": 8192,
              "can_reason": true
            },
            {
              "id": "deepseek-ai/deepseek-v3.2-exp",
              "name": "deepseek-ai/deepseek-v3.2-exp",
              "context_window": 200000,
              "default_max_tokens": 8192
            },
            {
              "id": "TEE/deepseek-chat-v3-0324",
              "name": "TEE/deepseek-chat-v3-0324",
              "context_window": 200000,
              "default_max_tokens": 8192
            },
            {
              "id": "TEE/deepseek-r1-70b-distill",
              "name": "TEE/deepseek-r1-70b-distill",
              "context_window": 200000,
              "default_max_tokens": 8192,
              "can_reason": true
            },
            {
              "id": "TEE/llama3-3-70b",
              "name": "TEE/llama3-3-70b",
              "context_window": 200000,
              "default_max_tokens": 8192
            },
            {
              "id": "TEE/gpt-oss-120b",
              "name": "TEE/gpt-oss-120b",
              "context_window": 200000,
              "default_max_tokens": 8192
            },
            {
              "id": "claude-opus-4-20250514",
              "name": "Claude 4 Opus",
              "context_window": 200000,
              "default_max_tokens": 8192
            },
            {
              "id": "claude-opus-4-thinking",
              "name": "Claude 4 Opus Thinking",
              "context_window": 200000,
              "default_max_tokens": 8192,
              "can_reason": true
            },
            {
              "id": "claude-sonnet-4-20250514",
              "name": "Claude 4 Sonnet",
              "context_window": 200000,
              "default_max_tokens": 8192
            },
            {
              "id": "claude-3-7-sonnet-20250219",
              "name": "Claude 3.7 Sonnet",
              "context_window": 200000,
              "default_max_tokens": 8192
            },
            {
              "id": "claude-3-5-sonnet-20241022",
              "name": "Claude 3.5 Sonnet",
              "context_window": 200000,
              "default_max_tokens": 8192
            },
            {
              "id": "gemini-2.5-pro",
              "name": "Gemini 2.5 Pro",
              "context_window": 200000,
              "default_max_tokens": 8192
            },
            {
              "id": "deepseek-r1",
              "name": "NanoGPT DeepSeek-R1 (No Deepseek)",
              "context_window": 200000,
              "default_max_tokens": 8192,
              "can_reason": true
            },
            {
              "id": "deepseek-ai/deepseek-v3.2-exp-thinking",
              "name": "NanoGPT DeepSeek V3.2 Thinking",
              "context_window": 200000,
              "default_max_tokens": 8192,
              "can_reason": true
            },
            {
              "id": "claude-3-7-sonnet-reasoner",
              "name": "Claude 3.7 Sonnet Reasoner",
              "context_window": 200000,
              "default_max_tokens": 8192,
              "can_reason": true
            },
            {
              "id": "claude-4-sonnet-thinking",
              "name": "Claude 4 Sonnet Thinking",
              "context_window": 200000,
              "default_max_tokens": 8192,
              "can_reason": true
            },
            {
              "id": "claude-sonnet-4-5-20250929",
              "name": "Claude 4.5 Sonnet",
              "context_window": 200000,
              "default_max_tokens": 8192
            },
            {
              "id": "claude-sonnet-4-5-20250929-thinking",
              "name": "Claude 4.5 Sonnet Thinking",
              "context_window": 200000,
              "default_max_tokens": 8192,
              "can_reason": true
            },
            {
              "id": "claude-3-7-sonnet-thinking",
              "name": "Claude 3.7 Sonnet Thinking",
              "context_window": 200000,
              "default_max_tokens": 8192,
              "can_reason": true
            },
            {
              "id": "claude-3-5-sonnet-20240620",
              "name": "Claude 3.5 Sonnet (June)",
              "context_window": 200000,
              "default_max_tokens": 8192
            },
            {
              "id": "claude-haiku-4-5-20251001",
              "name": "Claude 4.5 Haiku",
              "context_window": 200000,
              "default_max_tokens": 8192
            },
            {
              "id": "claude-3-5-haiku-20241022",
              "name": "Claude 3.5 Haiku",
              "context_window": 200000,
              "default_max_tokens": 8192
            },
            {
              "id": "claude-3-opus-20240229",
              "name": "Claude 3 Opus",
              "context_window": 200000,
              "default_max_tokens": 8192
            },
            {
              "id": "gpt-5-chat-latest",
              "name": "GPT-5 Chat Latest",
              "context_window": 200000,
              "default_max_tokens": 8192
            },
            {
              "id": "gpt-5.1-chat",
              "name": "GPT-5.1 Chat",
              "context_window": 200000,
              "default_max_tokens": 8192
            },
            {
              "id": "gpt-5-codex",
              "name": "GPT-5 Codex",
              "context_window": 200000,
              "default_max_tokens": 8192
            },
            {
              "id": "gpt-5.1-codex",
              "name": "GPT-5.1 Codex",
              "context_window": 200000,
              "default_max_tokens": 8192
            },
            {
              "id": "gpt-5-mini",
              "name": "GPT-5 Mini",
              "context_window": 200000,
              "default_max_tokens": 8192
            },
            {
              "id": "o1-preview",
              "name": "OpenAI O1 Preview",
              "context_window": 200000,
              "default_max_tokens": 8192,
              "can_reason": true
            },
            {
              "id": "o3-mini",
              "name": "OpenAI O3 Mini",
              "context_window": 200000,
              "default_max_tokens": 8192,
              "can_reason": true
            },
            {
              "id": "o3-pro",
              "name": "OpenAI O3 Pro",
              "context_window": 200000,
              "default_max_tokens": 8192,
              "can_reason": true
            },
            {
              "id": "qwen/qwen3-coder",
              "name": "Qwen 3 Coder",
              "context_window": 200000,
              "default_max_tokens": 8192
            },
            {
              "id": "qwen/qwen3-coder-plus",
              "name": "Qwen 3 Coder Plus",
              "context_window": 200000,
              "default_max_tokens": 8192
            },
            {
              "id": "Qwen/Qwen2.5-Coder-32B-Instruct",
              "name": "Qwen 2.5 Coder 32B",
              "context_window": 200000,
              "default_max_tokens": 8192
            },
            {
              "id": "deepseek-ai/DeepSeek-R1-0528",
              "name": "DeepSeek R1 Original",
              "context_window": 200000,
              "default_max_tokens": 8192,
              "can_reason": true
            },
            {
              "id": "gemini-2.0-pro-exp-02-05",
              "name": "Gemini 2.0 Pro Exp",
              "context_window": 200000,
              "default_max_tokens": 8192
            },
            {
              "id": "x-ai/grok-4-fast",
              "name": "Grok 4 Fast",
              "context_window": 200000,
              "default_max_tokens": 8192
            },
            {
              "id": "x-ai/grok-code-fast-1",
              "name": "Grok Code Fast",
              "context_window": 200000,
              "default_max_tokens": 8192
            },
            {
              "id": "gpt-4o-mini",
              "name": "GPT-4o Mini",
              "context_window": 200000,
              "default_max_tokens": 8192
            },
            {
              "id": "chatgpt-4o-latest",
              "name": "ChatGPT-4o Latest",
              "context_window": 200000,
              "default_max_tokens": 8192
            },
            {
              "id": "sonar-reasoning-pro",
              "name": "Sonar Reasoning Pro",
              "context_window": 200000,
              "default_max_tokens": 8192,
              "can_reason": true
            },
            {
              "id": "gemini-2.5-flash",
              "name": "Gemini 2.5 Flash",
              "context_window": 200000,
              "default_max_tokens": 8192
            },
            {
              "id": "meta-llama/llama-4-scout",
              "name": "Llama 4 Scout",
              "context_window": 200000,
              "default_max_tokens": 8192
            },
            {
              "id": "meta-llama/llama-4-maverick",
              "name": "Llama 4 Maverick",
              "context_window": 200000,
              "default_max_tokens": 8192
            },
            {
              "id": "deepcogito/cogito-v2.1-671b",
              "name": "Cogito V2.1 671B",
              "context_window": 200000,
              "default_max_tokens": 8192,
              "can_reason": true
            },
            {
              "id": "gpt-4o-reasoner",
              "name": "GPT-4o Reasoner",
              "context_window": 200000,
              "default_max_tokens": 8192,
              "can_reason": true
            }
          ]
        },
        "ollama": {
          "type": "openai-compat",
          "base_url": "http://localhost:11434/v1",
          "api_key": "ollama",
          "models": [
            {
              "id": "llama3.1:8b",
              "name": "Llama 3.1 8B",
              "context_window": 128000,
              "default_max_tokens": 8192
            },
            {
              "id": "nomic-embed-text:latest",
              "name": "Nomic Embed",
              "context_window": 8192,
              "default_max_tokens": 8192
            },
            {
              "id": "Qwen2.5-Coder-32B-Instruct",
              "name": "Qwen 2.5 Coder 32B",
              "context_window": 32768,
              "default_max_tokens": 8192
            },
            {
              "id": "deepseek-r1:32b",
              "name": "DeepSeek R1 Distill Qwen 32B",
              "context_window": 64000,
              "default_max_tokens": 8192,
              "can_reason": true
            },
            {
              "id": "deepseek-r1:14b",
              "name": "DeepSeek R1 Distill Qwen 14B",
              "context_window": 64000,
              "default_max_tokens": 8192,
              "can_reason": true
            },
            {
              "id": "llama4:scout",
              "name": "Llama 4 Scout",
              "context_window": 128000,
              "default_max_tokens": 8192
            }
          ]
        }
      },
      "mcp": {
        "context7": {
          "type": "stdio",
          "command": "podman",
          "args": ["run", "-i", "--rm", "context7-mcp"],
          "timeout": 120,
          "disabled": false,
          "env": {
            "CONTEXT7_API_KEY": "$(echo $CONTEXT7_API_KEY)"
          }
        },
        "playwright": {
          "type": "http",
          "url": "http://localhost:8931/mcp",
          "timeout": 120,
          "disabled": false,
          "headers": {
            "Content-Type": "application/json"
          }
        }
      },
      "permissions": {
        "allowed_tools": [
          "view",
          "ls",
          "grep",
          "edit",
          "write",
          "multiedit",
          "bash",
          "fetch",
          "agentic_fetch",
          "glob",
          "mcp_context7_get-library-doc",
          "mcp_context7_search-library-docs",
          "mcp_playwright_navigate",
          "mcp_playwright_screenshot",
          "mcp_playwright_click",
          "mcp_playwright_type",
          "mcp_playwright_get-page-content",
          "mcp_playwright_wait-for-element"
        ]
      },
      "lsp": {
        "nix": {
          "command": "nil"
        },
        "python": {
          "command": "python-lsp-server",
          "args": ["--stdio"]
        },
        "bash": {
          "command": "bash-language-server",
          "args": ["start"]
        },
        "go": {
          "command": "gopls"
        },
        "typescript": {
          "command": "typescript-language-server",
          "args": ["--stdio"]
        },
        "html": {
          "command": "vscode-html-language-server",
          "args": ["--stdio"]
        },
        "css": {
          "command": "vscode-css-language-server",
          "args": ["--stdio"]
        },
        "rust": {
          "command": "rust-analyzer"
        }
      },
      "options": {
        "debug": false
      }
    }
  '';

  home.file = {
    # Aider settings
    ".aider.conf.yml".text = ''
    # Specify the model to use for the main chat
    model: openai/TEE/deepseek-r1-70b

    # Editor model
    editor-model: openai/TEE/qwen-2.5-7b-instruct

    # Specify the api base url
    openai-api-base: https://nano-gpt.com/api/v1

    # Turn off auto commits
    auto-commits: false

    # Show diffs when committing changes
    show-diffs: true

    # Disable automatic acceptance of architect changes
    auto-accept-architect: false

    # Vim mode
    vim: true

    # Voice settings
    #voice-input-device: xxx

    # Appearance
    #dark-mode: true
    #pretty: true
    #code-theme: one-dark
    #fancy-input: true

    # Shell
    #shell-completions: zsh
    '';

    # Aider models
    ".aider.model.metadata.json".text = ''
    {
            "openai/deepseek-r1-nano": {
                    "edit_format": "diff",
                    "max_tokens": 8192,
                    "include_reasoning": true,
                    "max_input_tokens": 65536,
                    "max_output_tokens": 8192,
                    "input_cost_per_token": 0.00000046,
                    "output_cost_per_token": 0.00000195,
                    "litellm_provider": "openai",
                    "supports_reasoning": true,
                    "mode": "chat"
            },
            "openai/TEE/deepseek-r1-70b": {
                    "edit_format": "diff",
                    "max_tokens": 8192,
                    "include_reasoning": true,
                    "max_input_tokens": 65536,
                    "max_output_tokens": 8192,
                    "input_cost_per_token": 0.00000030,
                    "output_cost_per_token": 0.00000105,
                    "litellm_provider": "openai",
                    "supports_reasoning": true,
                    "mode": "chat"
            },
            "openai/Qwen/Qwen2.5-Coder-32B-Instruct": {
                    "max_tokens": 8192,
                    "max_input_tokens": 16384,
                    "max_output_tokens": 4096,
                    "input_cost_per_token": 0.00000027,
                    "output_cost_per_token": 0.00000027,
                    "litellm_provider": "openai",
                    "mode": "chat"
            },
            "openai/TEE/qwen-2.5-7b-instruct": {
                    "max_tokens": 8192,
                    "max_input_tokens": 16384,
                    "max_output_tokens": 4096,
                    "input_cost_per_token": 0.00000060,
                    "output_cost_per_token": 0.00000060,
                    "litellm_provider": "openai",
                    "mode": "chat"
            },
            "TEE/hermes-3-llama-3.1-70b": {
                    "edit_format": "diff",
                    "max_tokens": 8192,
                    "include_reasoning": true,
                    "max_input_tokens": 65536,
                    "max_output_tokens": 8192,
                    "input_cost_per_token": 0.00000075,
                    "output_cost_per_token": 0.00000075,
                    "litellm_provider": "openai",
                    "supports_reasoning": true,
                    "mode": "chat"
            }
    }
    '';

    # Goose config
    ".config/goose/config.yaml".text = ''
    # Model Configuration
    GOOSE_PROVIDER: "openai"
    GOOSE_MODEL: "TEE/deepseek-r1-70b-distill"
    GOOSE_TEMPERATURE: 0.7

    # Planning Configuration
    GOOSE_PLANNER_PROVIDER: "openai"
    GOOSE_PLANNER_MODEL: "TEE/deepseek-r1-70b"

    # Nano-GPT Endpoint Configuration
    #OPENAI_API_KEY:
    # ^ set in environment by sops-nix + programs.zsh.initContent
    OPENAI_HOST: "https://nano-gpt.com"

    # Tool Configuration
    GOOSE_MODE: "smart_approve"
    GOOSE_TOOLSHIM: true
    GOOSE_CLI_MIN_PRIORITY: 0.2

    # Extensions Configuration
    extensions:
      developer:
        bundled: true
        enabled: true
        name: developer
        timeout: 300
        type: builtin

    memory:
      bundled: true
      enabled: true
      name: memory
      timeout: 300
      type: builtin
    '';

    ".config/open-interpreter/profiles/default.yaml".text = ''
      # Open Interpreter Default Profile
      # Version must be set for YAML profiles
      version: 0.2.5

      # Language Model settings
      llm:
        # Specify the model to use, consistent with your other agent configs
        model: TEE/deepseek-chat-v3-0324

        # Specify the API base URL for your nano-gpt endpoint
        api_base: https://nano-gpt.com 
        #/api/v1

        # API key is read from the OPENAI_API_KEY environment variable, so it's not needed here.

        # Set temperature for creativity, similar to your goose config
        temperature: 0.7

        # Assume your model/endpoint supports function calling for more reliable execution
        supports_functions: true

        context_window: 32000
        max_tokens: 4000

      # General Configuration
      # Ask for confirmation before running code, similar to your other tool preferences
      auto_run: false

      # Enable safety mechanisms and ask for confirmation
      safe_mode: ask

      # Opt out of telemetry
      disable_telemetry: true

      # Add custom instructions here to give the interpreter context about your system
      custom_instructions: "I am running NixOS. Please be mindful that system modifications should be done through my configuration files."
    '';   

    # Plandex config
    ".config/plandex/models.json".text = ''
    {
      "$schema": "https://plandex.ai/schemas/models-input.schema.json",

      "providers": [
        {
          "name": "nanogpt",
          "baseUrl": "https://nano-gpt.com/api/v1",
          "apiKeyEnvVar": "OPENAI_API_KEY"
        }
      ],

      "models": [
        {
          "modelId": "nanogpt/deepseek-r1-70b",
          "publisher": "nanogpt",
          "description": "Deepseek v2 70B via Nano-GPT",
          "maxTokens": 73728,
          "maxOutputTokens": 8192,
          "providers": [
            {
              "provider": "custom",
              "customProvider": "nanogpt",
              "modelName": "openai/TEE/deepseek-r1-70b"
            }
          ]
        },
        {
          "modelId": "nanogpt/qwen-2.5-7b-instruct",
          "publisher": "nanogpt",
          "description": "Qwen 2.5 7B Instruct via Nano-GPT",
          "maxTokens": 20480,
          "maxOutputTokens": 4096,
          "providers": [
            {
              "provider": "custom",
              "customProvider": "nanogpt",
              "modelName": "openai/TEE/qwen-2.5-7b-instruct"
            }
          ]
        }
      ],

      "modelPacks": [
        {
          "name": "nanogpt-default",
          "description": "Uses Deepseek for planning and Qwen for coding via the custom Nano-GPT provider.",
          "planner": "nanogpt/deepseek-r1-70b",
          "architect": "nanogpt/deepseek-r1-70b",
          "coder": "nanogpt/qwen-2.5-7b-instruct",
          "builder": "nanogpt/qwen-2.5-7b-instruct",
          "summarizer": "nanogpt/qwen-2.5-7b-instruct",
          "names": "nanogpt/qwen-2.5-7b-instruct",
          "commitMessages": "nanogpt/qwen-2.5-7b-instruct",
          "autoContinue": "nanogpt/qwen-2.5-7b-instruct"
        }
      ]
    }
    '';

    # # OpenCode Configuration
    # ".config/opencode/opencode.jsonc".text = ''
      # {
      #   "$schema": "https://opencode.ai/config.json",
      #   "model": "nano-gpt/z-ai/glm-4.6",
      #   "provider": {
      #     "nano-gpt": {
      #       "models": {
      #         "z-ai/glm-4.6": {
      #           "name": "z-ai/glm-4.6"
      #         }
      #       },
      #       "name": "Nano GPT",
      #       "npm": "@ai-sdk/openai-compatible",
      #       "options": {
      #         "apiKey": "placeholder",
      #         "baseURL": "https://nano-gpt.com/api/v1"
      #       }
      #     }
      #   },
      #   "tui": {
      #     "theme": "catppuccin"
      #   }
      # }
    # '';

    # Mods configuration
    ".config/mods/mods.yml".text = ''
      default-api: openai
      default-model: TEE/deepseek-chat-v3-0324
      format: false
      role: cli
      raw: false
      quiet: false
      temp: 0.3
      topp: 1.0
      topk: 50
      no-limit: false
      word-wrap: 80
      include-prompt-args: false
      include-prompt: 0
      max-retries: 5
      fanciness: 10
      status-text: Generating
      theme: charm
      max-input-chars: 100000
      max-tokens: 4096
      max-completion-tokens: 4096
      
      format-text:
        markdown: Format the response as markdown without enclosing backticks.
        json: Format the response as json without enclosing backticks.
      
      roles:
        "default": []
        cli:
          - You are a CLI expert assistant
          - Generate precise, safe command-line instructions
          - Provide exact commands with proper syntax
          - Include necessary flags and options
          - Explain dangerous operations
          - Suggest safer alternatives when possible
          - Format responses clearly with code blocks
          - Be concise but thorough
        pipe:
          - You are a CLI command generator for piping
          - Output ONLY the command, nothing else
          - No explanations, no code blocks, no formatting
          - Just the raw command that should be executed
          - Choose the most likely/safest command if multiple options exist
          - Never include explanations or safety warnings
          - Never use markdown formatting
          - Output should be directly pipable to shell
      
      apis:
        openai:
          base-url: https://nano-gpt.com/api/v1
          api-key-env: OPENAI_API_KEY
          models:
            TEE/deepseek-r1-70b-distill:
              aliases: ["deepseek-r1"]
              max-input-chars: 100000
            TEE/deepseek-chat-v3-0324:
              aliases: ["deepseek-chat"]
              max-input-chars: 100000
            TEE/llama3-3-70b:
              aliases: ["llama3-70b"]
              max-input-chars: 100000
    '';


  # end home.file
  };

}
