{ config, pkgs, inputs, ... }:

{
  # Enable the microvm host functionality
  microvm.host.enable = true;

  # Define the Firefox microVM
  microvm.vms.firefox = {
    # VM configuration
    config = { pkgs, ... }: {
      system.stateVersion = "24.05";
      networking.hostName = "firefox-vm";
      
      # Apply microvm overlay to get cloud-hypervisor-graphics
      nixpkgs.overlays = [ inputs.microvm.overlays.default ];
      
      microvm = {
        hypervisor = "cloud-hypervisor";
        vcpu = 4;
        mem = 4096;
        # Enable graphics for GUI apps
        graphics = {
          enable = true;
        };
        # Share the host's /nix/store (cloud-hypervisor uses virtiofs)
        shares = [
          {
            tag = "ro-store";
            source = "/nix/store";
            mountPoint = "/nix/store";
            proto = "virtiofs";
            socket = "ro-store.sock";
            readOnly = true;
          }
          # Share the Downloads folder
          {
            tag = "downloads";
            source = "/home/nebula/Downloads";
            mountPoint = "/home/nebula/Downloads";
            proto = "virtiofs";
            socket = "downloads.sock";
          }
        ];
      };
      
      users.users.nebula = {
        isNormalUser = true;
        password = "nebula";
        extraGroups = [ "audio" "video" "input" "wheel" ];
      };
      
      environment.systemPackages = with pkgs; [
        firefox
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
      ];
      
      services.getty.autologinUser = "nebula";
      
      # Enable sound
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
      };
      
      # Enable sudo without password for convenience
      security.sudo = {
        enable = true;
        wheelNeedsPassword = false;
      };
    };
  };
}