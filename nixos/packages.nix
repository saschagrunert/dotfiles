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

    # Debugging & profiling
    lm_sensors
    lshw
    usbutils
  ];
}
