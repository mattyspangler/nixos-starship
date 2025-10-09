{
  config,
  lib,
  pkgs,
  ...
}:
{

  home.packages = with pkgs; [
    #ollama-rocm # wasn't finding amd gpu libraries as of 5/15/25
    gpt4all
    aichat
    #shell-gpt
    aider-chat
    jq # used by my script that pulls ollama models
    openai-whisper
    goose-cli
    koboldcpp
    plandex
    open-interpreter
    opencode
  ];

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
        model: openai/TEE/deepseek-r1-70b

        # Specify the API base URL for your nano-gpt endpoint
        api_base: https://nano-gpt.com/api/v1

        # API key is read from the OPENAI_API_KEY environment variable, so it's not needed here.

        # Set temperature for creativity, similar to your goose config
        temperature: 0.7

        # Assume your model/endpoint supports function calling for more reliable execution
        supports_functions: true

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

    # OpenCode Configuration
    ".config/opencode/opencode.json".text = ''
    {
      "$schema": "https://opencode.ai/config.json",

      // Provider Configuration
      // We configure the built-in 'openai' provider to point to your custom endpoint.
      // The API key is securely referenced from your environment variables.
      "provider": {
        "openai": {
          "options": {
            "baseUrl": "https://nano-gpt.com/api/v1",
            "apiKey": "{env:OPENAI_API_KEY}"
          }
        }
      },

      // Model Selection
      // Using your powerful model for main tasks and the smaller model for quick tasks.
      "model": "openai/TEE/deepseek-r1-70b",
      "small_model": "openai/TEE/qwen-2.5-7b-instruct",

      // Permissions
      // A good safety measure: ask for user confirmation before executing
      // potentially destructive commands like editing files or running shell commands.
      "permission": {
        "edit": "ask",
        "bash": "ask"
      },

      // Enable automatic updates for the tool
      "autoupdate": true
    }
    '';


  # end home.file
  };

}
