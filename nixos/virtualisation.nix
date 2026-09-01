_: {
  virtualisation = {
    containers = {
      enable = true;
      ociSeccompBpfHook.enable = true;
    };
    cri-o.enable = true;

    libvirtd = {
      enable = true;
      qemu.swtpm.enable = true;
    };
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  systemd.services.crio.enable = false;
}
