{ config, lib, pkgs, ... }:
{
  boot = {
    enableContainers = false;
    initrd = {
      availableKernelModules = [
        "ahci"
        "nvme"
        "rtsx_pci_sdmmc"
        "sd_mod"
        "thunderbolt"
        "usb_storage"
        "xhci_pci"
      ];
      kernelModules = [
        "amdgpu"
        "dm-snapshot"
      ];
      luks.devices = {
        crypted = {
          device = "/dev/disk/by-uuid/37979e33-77a8-4b2e-8bff-7d0ae8850266";
          preLVM = true;
        };
      };
    };
    kernel = {
      sysctl = {
        "net.ipv4.conf.all.forwarding" = 1;
        "net.ipv4.conf.all.route_localnet" = 1;
        "net.ipv4.conf.default.forwarding" = 1;
        "net.ipv4.ip_unprivileged_port_start" = 0;
      };
    };
    kernelModules = [ "kvm-amd" ];
    #kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "video=DisplayPort-7:3840x2160@60"
      "video=DisplayPort-9:3840x2160@60"
      "video=eDP:1920x1200@60"
    ];
    extraModulePackages = [ ];
    tmp = {
      useTmpfs = true;
    };
    loader = {
      timeout = 0;
      efi.canTouchEfiVariables = true;
      grub = {
        configurationLimit = 2;
        enable = true;
        efiSupport = true;
        enableCryptodisk = true;
        device = "nodev";
      };
    };
  };
}
