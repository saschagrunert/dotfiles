{ config, lib, pkgs, ... }:
{
  virtualisation = {
    containers = {
      enable = true;
      ociSeccompBpfHook.enable = true;
    };
    cri-o.enable = true;
    docker.enable = true;
    libvirtd.enable = true;
    podman.enable = true;
  };

  systemd.services.crio.enable = false;
}
