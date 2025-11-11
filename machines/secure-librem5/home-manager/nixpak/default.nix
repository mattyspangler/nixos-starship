{ pkgs, lib, nixpak, ... }:

let
  # This wrapper is essential for bubblewrap to function correctly on postmarketOS
  # by dropping ambient capabilities that interfere with its operation.
  bwrap-without-ambient-caps = pkgs.writeShellScriptBin "bwrap" ''
    #!${pkgs.runtimeShell}
    exec ${pkgs.util-linux}/bin/setpriv --ambient-caps '-all' ${pkgs.bubblewrap}/bin/bwrap "$@"
  '';
in
{
  # Import the main nixpak module to enable its features.
  imports = [ nixpak.homeManagerModules.nixpak ];

  # Configure nixpak to use our custom bubblewrap wrapper.
  programs.nixpak.bubblewrap = bwrap-without-ambient-caps;

  # Define your sandboxed applications here.
  # Each application will be automatically wrapped by nixpak and made available
  # in your environment.
  programs.nixpak.packages = {
    # Example: Sandbox the 'neofetch' command.
    # This basic profile provides a minimal, isolated environment.
    neofetch = {
      package = pkgs.neofetch;
      profile = {
        # The 'generic' profile is a good starting point. It provides a basic
        # filesystem layout and isolates the application from your home directory.
    name = "generic";
    # We can add extra arguments to bubblewrap for more fine-grained control.
    extraArgs = [
      "--ro-bind" "/etc/os-release" "/etc/os-release" # Allow reading OS info
    ];
  };
};

# Your specific CLI applications to sandbox
toot = {
  package = pkgs.toot;
  profile = {
    name = "generic";
    extraArgs = [
      "--ro-bind" "/etc/os-release" "/etc/os-release"
    ];
  };
};

iamb = {
  package = pkgs.iamb;
  profile = {
    name = "generic";
    extraArgs = [
      "--proc" "/proc" # Allow access to process information
    ];
  };
};

gurk-rs = {
  package = pkgs.gurk-rs;
  profile = {
    name = "generic";
    extraArgs = [
      "--ro-bind" "/etc/os-release" "/etc/os-release"
    ];
  };
};

lynx = {
  package = pkgs.lynx;
  profile = {
    name = "generic";
    extraArgs = [
      "--ro-bind" "/etc/os-release" "/etc/os-release"
    ];
  };
};

dillo = {
  package = pkgs.dillo;
  profile = {
    name = "generic";
    extraArgs = [
      "--ro-bind" "/etc/os-release" "/etc/os-release"
    ];
  };
};

profanity = {
  package = pkgs.profanity;
  profile = {
    name = "generic";
    extraArgs = [
      "--ro-bind" "/etc/os-release" "/etc/os-release"
    ];
  };
};

tuisky = {
  package = pkgs.tuisky;
  profile = {
    name = "generic";
    extraArgs = [
      "--ro-bind" "/etc/os-release" "/etc/os-release"
    ];
  };
};

weechat = {
  package = pkgs.weechat;
  profile = {
    name = "generic";
    extraArgs = [
      "--ro-bind" "/etc/os-release" "/etc/os-release"
    ];
  };
};
}