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
            }
    }
    '';

    # Goose config
    ".config/goose/config.yaml".text = ''
    # Model Configuration
    GOOSE_PROVIDER: "openai"
    GOOSE_MODEL: "TEE/deepseek-r1-70b"
    GOOSE_TEMPERATURE: 0.7

    # Planning Configuration
    GOOSE_PLANNER_PROVIDER: "openai"
    GOOSE_PLANNER_MODEL: "TEE/qwen-2.5-7b-instruct"

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
  # end home.file
  };

}
