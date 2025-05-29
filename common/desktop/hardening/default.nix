# Referencing information from these hardening guides:
# - https://madaidans-insecurities.github.io/guides/linux-hardening.html
# - https://medium.com/@ganga.jaiswal/build-a-hardened-linux-system-with-nixos-88bb7d77ba22
# - https://xeiaso.net/blog/paranoid-nixos-2021-07-18/

{
  config,
  lib,
  pkgs, 
  ... 
}:

with lib;

{

  imports = [
    ./apparmor
    ./network
    ./clamav
    ./aide
    ./noexec
    ./yubikey
    ./nix-mineral
  ];

  # Hardened malloc disables user namespaces, which breaks flatpak.
  # Unfortunately, this forces me to turn user namespaces back on until there is a workaround.
  # - https://forums.whonix.org/t/bug-hardened-malloc-ignored-by-flatpaks/18199
  # - https://gitlab.com/freedesktop-sdk/freedesktop-sdk/-/issues/1680
  # It is also required by podman to run containers in rootless mode.
  # Apparmor might have a way to mitigate some of the risk from user namespaces:
  # - https://discourse.ubuntu.com/t/spec-unprivileged-user-namespace-restrictions-via-apparmor-in-ubuntu-23-10/37626
  # - https://askubuntu.com/questions/1497276/why-is-user-max-user-namespaces-enabled-in-ubuntu-by-default
  nix.settings.allowed-users = mkDefault [ "@users" ];

  environment = { 
    memoryAllocator.provider = mkDefault "scudo";
    variables.SCUDO_OPTIONS = mkDefault "ZeroContents=1";
  };

  security = {
    unprivilegedUsernsClone = mkDefault config.virtualisation.containers.enable;

    lockKernelModules = mkDefault true;

    protectKernelImage = mkDefault true;

    allowSimultaneousMultithreading = mkDefault false;

    forcePageTableIsolation = mkDefault true;

    virtualisation.flushL1DataCache = mkDefault "always";

    apparmor = {
      enable = mkDefault true;
      killUnconfinedConfinables = mkDefault true;
    };
  }; # end security block

  boot = {

    # Todo: tweak kernel settings for security:
    # - http://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project/Recommended_Settings
    # - https://github.com/NixOS/nixpkgs/blob/nixos-23.11/pkgs/os-specific/linux/kernel/hardened/config.nix 
    kernelPackages = lib.mkDefault pkgs.linuxPackages_hardened;

    kernelParams = [
      # Don't merge slabs
      "slab_nomerge"

      # Overwrite free'd pages
      "page_poison=1"

      # Enable page allocator randomization
      "page_alloc.shuffle=1"

      # Disable debugfs
      "debugfs=off"
    ];

    blacklistedKernelModules = [
      # Obscure network protocols
      "ax25"
      "netrom"
      "rose"

      # Old or rare or insufficiently audited filesystems
      "adfs"
      "affs"
      "bfs"
      "befs"
      "cramfs"
      "efs"
      "erofs"
      "exofs"
      "freevxfs"
      "f2fs"
      "hfs"
      "hpfs"
      "jfs"
      "minix"
      "nilfs2"
      "ntfs"
      "omfs"
      "qnx4"
      "qnx6"
      "sysv"
      "ufs"
    ];

    kernel = {
      sysctl = {

        "user.max_user_namespaces" = lib.mkDefault 63557; # the default I observed with 'sysctl -a'

        # Hide kptrs even for processes with CAP_SYSLOG
        "kernel.kptr_restrict" = mkOverride 500 2;

        # Disable bpf() JIT (to eliminate spray attacks)
        "net.core.bpf_jit_enable" = mkDefault false;

        # Disable ftrace debugging
        "kernel.ftrace_enabled" = mkDefault false;

        # Enable strict reverse path filtering (that is, do not attempt to route
        # packets that "obviously" do not belong to the iface's network; dropped
        # packets are logged as martians).
        "net.ipv4.conf.all.log_martians" = mkDefault true;
        "net.ipv4.conf.all.rp_filter" = mkDefault "1";
        "net.ipv4.conf.default.log_martians" = mkDefault true;
        "net.ipv4.conf.default.rp_filter" = mkDefault "1";

        # Ignore broadcast ICMP (mitigate SMURF)
        "net.ipv4.icmp_echo_ignore_broadcasts" = mkDefault true;

        # Ignore incoming ICMP redirects (note: default is needed to ensure that the
        # setting is applied to interfaces added after the sysctls are set)
        "net.ipv4.conf.all.accept_redirects" = mkDefault false;
        "net.ipv4.conf.all.secure_redirects" = mkDefault false;
        "net.ipv4.conf.default.accept_redirects" = mkDefault false;
        "net.ipv4.conf.default.secure_redirects" = mkDefault false;
        "net.ipv6.conf.all.accept_redirects" = mkDefault false;
        "net.ipv6.conf.default.accept_redirects" = mkDefault false;

        # Ignore outgoing ICMP redirects (this is ipv4 only)
        "net.ipv4.conf.all.send_redirects" = mkDefault false;
        "net.ipv4.conf.default.send_redirects" = mkDefault false;

      }; # end sysctl block

    }; # end kernel block

  }; # end boot block

  # disable coredump that could be exploited later
  # and also slow down the system when something crashes
  systemd.coredump.enable = false;

  programs.firejail.enable = true;

}
