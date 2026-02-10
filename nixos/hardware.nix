{ config, lib, pkgs, ... }:
{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/f436cabf-2f00-4ca2-aa5f-bebbeffb3a18";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/BA23-E4AC";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/7b5f80d4-b31d-4619-b8c4-c3fcae0441a9"; }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
  };

  hardware = {
    amdgpu.overdrive.enable = true;
    bluetooth.enable = true;
    cpu.amd.updateMicrocode = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
