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
              "context_window": 128000,
              "default_max_tokens": 8192
            },
            {
              "id": "z-ai/glm-4.6:thinking",
              "name": "z-ai/glm-4.6:thinking",
              "cost_per_1m_in": 0.38,
              "cost_per_1m_out": 1.42,
              "cost_per_1m_in_cached": 0.38,
              "cost_per_1m_out_cached": 1.42,
              "context_window": 128000,
              "default_max_tokens": 8192,
              "can_reason": true
            },
            {
              "id": "deepseek-ai/deepseek-v3.2-exp",
              "name": "deepseek-ai/deepseek-v3.2-exp",
              "context_window": 64000,
              "default_max_tokens": 8192
            },
            {
              "id": "TEE/deepseek-chat-v3-0324",
              "name": "TEE/deepseek-chat-v3-0324",
              "context_window": 64000,
              "default_max_tokens": 8192
            },
            {
              "id": "TEE/deepseek-r1-70b-distill",
              "name": "TEE/deepseek-r1-70b-distill",
              "context_window": 64000,
              "default_max_tokens": 8192,
              "can_reason": true
            },
            {
              "id": "TEE/llama3-3-70b",
              "name": "TEE/llama3-3-70b",
              "context_window": 128000,
              "default_max_tokens": 8192
            },
            {
              "id": "TEE/gpt-oss-120b",
              "name": "TEE/gpt-oss-120b",
              "context_window": 32000,
              "default_max_tokens": 4096
            }
          ]
        }
      },
      "lsp": {
        "nix": {
          "command": "nil"
        },
        "python": {
          "command": "pylsp"
        },
        "bash": {
          "command": "bash-language-server"
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


  # end home.file
  };

}
