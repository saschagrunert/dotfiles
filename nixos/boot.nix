{ config, lib, pkgs, ... }:
{
  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];
      kernelModules = [ "dm-snapshot" ];
      luks.devices = {
        crypted = {
          device = "/dev/disk/by-uuid/d5d42ad3-d5d6-45ff-8723-44f15d7fcd9c";
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
    tmpOnTmpfs = false;
    loader = {
      timeout = 0;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      grub = {
        configurationLimit = 2;
        enable = true;
        version = 2;
        efiSupport = true;
        enableCryptodisk = true;
        device = "nodev";
      };
    };
  };
}
