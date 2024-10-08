{ config, lib, pkgs, ... }:
{
  boot = {
    enableContainers = false;
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "nvme"
        "ahci"
        "usb_storage"
        "sd_mod"
        "sdhci_pci"
        "rtsx_pci_sdmmc"
      ];
      kernelModules = [ "dm-snapshot" ];
      luks.devices = {
        crypted = {
          device = "/dev/disk/by-uuid/a6f2f4f1-8a59-4aa0-89b9-fdd94e573637";
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
    kernelModules = [ "kvm-intel" ];
    kernelPackages = pkgs.linuxPackages_latest;
    extraModulePackages = [ ];
    extraModprobeConfig = "options kvm_intel nested=1";
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
