{
  lib,
  pkgs,
  ...
}:
{

  services.ollama = {
    enable = true;
    #environmentVariables = {
    #  OLLAMA_MODELS = "~/.ollama/models";
    #};
    #package = "pkgs.ollama-rocm";
    home = "/var/lib/ollama";
    models = "/var/lib/ollama/models";
  #  loadModels = [
  #    #"deepseek-coder:6.7b"
  #    #"qwen2.5:32b"
  #  ];
  };

  environment.systemPackages = with pkgs; [
    #ollama-rocm # wasn't finding amd gpu libraries as of 5/15/25
    gpt4all
    aichat
    yai
    aider-chat
    jq # used by my script that pulls ollama models
  ];

}
