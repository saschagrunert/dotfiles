{ pkgs, ... }:
{
  # System-wide packages: everything root or a system service needs. User
  # session tooling lives in home/packages.nix, so changing it does not rebuild
  # the system closure.
  environment.systemPackages = with pkgs; [
    # Toolchains. Needed system-wide because they are also used through sudo,
    # for example the Kubernetes and CRI-O builds in fish/functions/kubernetes.fish.
    binutils
    clang_22
    gcc
    git
    gnumake
    go_1_27
    python3

    # Containers & virtualization
    cni-plugins
    conmon
    conmon-rs
    cri-tools
    crun
    fuse-overlayfs
    runc
    slirp4netns
    vagrant
    virt-manager

    # Kubernetes
    kubernetes

    # Networking & security
    conntrack-tools
    iptables
    openssl
    openvpn
    socat

    # Icon themes. mako/config names these by absolute path in the system
    # profile, so they have to be here rather than in home/packages.nix.
    # hicolor only resolved before because a GTK package happened to pull it in.
    hicolor-icon-theme
    papirus-icon-theme

    # Debugging & profiling
    lm_sensors
    lshw
    usbutils
  ];
}
