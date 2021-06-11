{ config, lib, pkgs, ... }:
{
  users.users.sascha = {
    isNormalUser = true;
    home = "/home/sascha";
    description = "Sascha Grunert";
    extraGroups = [
      "audio"
      "docker"
      "libvirtd"
      "networkmanager"
      "vboxusers"
      "video"
      "wheel"
    ];
    shell = pkgs.fish;
  };
}
