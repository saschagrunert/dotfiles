_: {
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/e5214043-e0a0-44f0-8fb3-f717ba26bd0e";
      fsType = "ext4";
      options = [ "noatime" "x-systemd.device-timeout=5min" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/8A2E-D229";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/dfaff609-4075-4842-bfb7-2d6e03ad5ee9"; } ];

  hardware = {
    xpadneo.enable = true;
    bluetooth.enable = true;
    cpu.amd.updateMicrocode = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
