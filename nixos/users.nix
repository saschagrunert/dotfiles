{ pkgs, ... }:
{
  users.users.sascha = {
    isNormalUser = true;
    description = "Sascha Grunert";
    extraGroups = [
      "audio"
      "docker"
      "libvirtd"
      "networkmanager"
      "video"
      "wheel"
    ];
    shell = pkgs.fish;
  };
}
