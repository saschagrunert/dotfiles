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

    # TODO: remove from NixOS 20.09 release
    subUidRanges = [{ startUid = 100000; count = 65536; }];
    subGidRanges = [{ startGid = 100000; count = 65536; }];
  };
}
