_: {
  virtualisation = {
    containers = {
      enable = true;
      ociSeccompBpfHook.enable = true;
    };
    cri-o.enable = true;

    libvirtd.enable = true;
    podman.enable = true;
  };

  systemd.services.crio.enable = false;
}
