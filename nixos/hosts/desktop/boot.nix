_: {
  boot = {
    initrd = {
      availableKernelModules = [
        "ahci"
        "nvme"
        "sd_mod"
        "usbhid"
        "usb_storage"
        "xhci_pci"
      ];
      kernelModules = [
        "amdgpu"
        "dm-snapshot"
      ];
      luks.devices = {
        crypted = {
          device = "/dev/disk/by-uuid/8696c19a-d6f5-49f3-85f3-14ffcad011fa";
          preLVM = true;
          allowDiscards = true;
        };
      };
    };
    kernel = {
      sysctl = {
        "net.ipv4.conf.all.forwarding" = 1;
        "net.ipv4.conf.all.route_localnet" = 1;
        "net.ipv4.conf.default.forwarding" = 1;
        "net.ipv4.ip_unprivileged_port_start" = 0;
        "vm.swappiness" = 10;
        "vm.vfs_cache_pressure" = 50;
      };
    };
    kernelModules = [ "kvm-amd" ];
    tmp.useTmpfs = true;
    loader = {
      timeout = 6;
      efi.canTouchEfiVariables = true;
      grub = {
        configurationLimit = 1;
        enable = true;
        efiSupport = true;
        enableCryptodisk = true;
        device = "nodev";
        useOSProber = true;
      };
    };
  };
}
