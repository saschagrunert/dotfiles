{ config, lib, pkgs, ... }:
{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/f7ff2198-47a7-4826-bff5-215128944553";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/DD06-C10E";
      fsType = "vfat";
    };
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/b7ea93e6-6bf8-48e1-a355-9f10601c4feb"; }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  environment.variables = {
    MESA_LOADER_DRIVER_OVERRIDE = "iris";
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
  };

  hardware = {
    cpu.intel.updateMicrocode = true;
    opengl.package = (pkgs.mesa.override {
      galliumDrivers = [ "nouveau" "virgl" "swrast" "iris" ];
    }).drivers;
    pulseaudio.enable = true;
  };

  sound.enable = true;
}
