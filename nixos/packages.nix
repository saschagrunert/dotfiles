{ pkgs, llvmVersion, ... }:
{
  # System-wide packages: everything root or a system service needs. User
  # session tooling lives in home/packages.nix. Both lists are part of the
  # system closure through the integrated Home Manager configuration.
  environment.systemPackages = with pkgs; [
    # Toolchains. Needed system-wide because they are also used through sudo,
    # for example the Kubernetes and CRI-O builds in fish/functions/kubernetes.fish.
    binutils
    pkgs."llvmPackages_${llvmVersion}".clang
    gcc
    git
    gnumake
    go_1_27
    python3

    # Containers & virtualization
    cni-plugins
    conmon
    conmon-rs
    crun
    fuse-overlayfs
    runc
    slirp4netns

    # Kubernetes
    kubernetes

    # Networking & security
    conntrack-tools
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
