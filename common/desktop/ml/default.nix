{
  lib,
  pkgs,
  ...
}:
{

  environment.systemPackages = with pkgs; [
    #ollama-rocm # wasn't finding amd gpu libraries as of 5/15/25
    gpt4all
    aichat
    aider-chat
    jq # used by my script that pulls ollama models
  ];

}
