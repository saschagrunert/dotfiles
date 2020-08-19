{ config, lib, pkgs, ... }:
{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/779bee49-db2e-4a03-9cdb-fca6156f855f";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/BCC6-032C";
      fsType = "vfat";
    };
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/3da6402f-aae6-4eb1-8b61-71681b654ba0"; }];
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  environment.variables = { MESA_LOADER_DRIVER_OVERRIDE = "iris"; };

  hardware = {
    cpu.intel.updateMicrocode = true;
    opengl.package = (pkgs.mesa.override {
      galliumDrivers = [ "nouveau" "virgl" "swrast" "iris" ];
    }).drivers;
    pulseaudio.enable = true;
  };

  sound.enable = true;
}
