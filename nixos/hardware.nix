{ config, lib, pkgs, ... }:
{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/a3e8a789-81cc-422b-8c50-183bbfdbfa8a";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/5AA3-6FE5";
      fsType = "vfat";
    };
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/708288a8-9726-41c4-84b2-65eba4782272"; }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
  };

  hardware = {
    bluetooth.enable = true;
    cpu.intel.updateMicrocode = true;
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
      driSupport32Bit = true;
    };
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      support32Bit = true;
      extraConfig = ''
        load-module module-switch-on-connect
      '';
    };
  };

  sound.enable = true;
}
