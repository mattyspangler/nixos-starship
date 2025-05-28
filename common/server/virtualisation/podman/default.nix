{ pkgs, ... }:
{

  imports = [
  ];

  # Enable common container config files in /etc/containers
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
    oci-containers = {
      backend = "podman";
    };
  };

  # Required for rootless containers
  # https://github.com/containers/podman/blob/main/docs/tutorials/rootless_tutorial.md#etcsubuid-and-etcsubgid-configuration
  users.extraUsers.nebula = {
    subUidRanges = [{ startUid = 100000; count = 65536; }];
    subGidRanges = [{ startGid = 100000; count = 65536; }];
  };

  users.users.nebula = {
    isNormalUser = true;
    extraGroups = [ "podman" ];
  };

  # Podman throws error: "systemd error: Interactive authentication required"
  # - https://unix.stackexchange.com/questions/650826/why-is-this-error-interactive-authentication-required-popping-up
  # - https://serverfault.com/questions/1122063/rootless-docker-fails-with-systemd-error-interactive-authentication-required
  # - https://github.com/NixOS/nixpkgs/issues/29095
  # - https://discourse.nixos.org/t/simulating-a-kubernetes-cluster-with-containers/26297/5
  # Extra stuff needed for k3s on 23.11:
  # - https://gist.github.com/zeratax/85f240b5547388ca4a45f70f8673bfbf
  systemd.extraConfig = ''
    DefaultCPUAccounting=yes
    DefaultIOAccounting=yes
    DefaultBlockIOAccounting=yes
    DefaultMemoryAccounting=yes
    DefaultTasksAccounting=yes
  '';
  #systemd.enableUnifiedCgroupHierarchy = true; # No longer works in NixOS, need to research if I still need this!
  boot.kernelParams = [ "cgroup_enable=memory" "swapaccount=1" ];

  # enable cgroups v2 in the container
  systemd.services."container@lab".environment.SYSTEMD_NSPAWN_UNIFIED_HIERARCHY = "1";

  # allow syscalls via an nspawn config file, because arguments with spaces work bad with containers.example.extraArgs
  environment.etc."systemd/nspawn/example.nspawn".text = ''
    [Exec]
    SystemCallFilter=add_key keyctl bpf
  '';

  # Useful otherdevelopment tools
  environment.systemPackages = with pkgs; [
    podman
    runc
    libcap
    fuse-overlayfs
    cni
    cni-plugins # https://github.com/containers/podman/issues/3679
    conmon
    skopeo
    slirp4netns
    shadow
    dbus
    which
    file
    dive # look into docker image layers
    podman-tui # status of containers in the terminal
    docker-compose # start group of containers for dev
    podman-compose # start group of containers for dev
    podman-desktop
  ];
}

