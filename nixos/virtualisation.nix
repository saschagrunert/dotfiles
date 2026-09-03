_: {
  virtualisation = {
    containers = {
      enable = true;
      ociSeccompBpfHook.enable = true;
    };
    # Module enabled for config generation, service intentionally disabled
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
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };

  systemd.services.crio.enable = false;
}
