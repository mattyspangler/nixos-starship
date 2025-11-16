{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nil  # Nix Language Server
    
    # Python
    python311Packages.python-lsp-server
    
    # Bash
    nodePackages.bash-language-server
    
    # Go
    gopls
    
    # JavaScript/TypeScript
    nodePackages.typescript-language-server
    
    # HTML/CSS
    nodePackages.vscode-langservers-extracted
    
    # Rust
    rust-analyzer
    
  ];
}