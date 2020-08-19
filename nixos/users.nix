{ config, lib, pkgs, ... }:
{
  users.users.sascha = {
    isNormalUser = true;
    home = "/home/sascha";
    description = "Sascha Grunert";
    extraGroups = [
      "audio"
      "networkmanager"
      "libvirtd"
      "video"
      "wheel"
    ];
    shell = pkgs.fish;
  };
}
