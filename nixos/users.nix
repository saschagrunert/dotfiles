{ pkgs, ... }:
{
  users.users.sascha = {
    isNormalUser = true;
    description = "Sascha Grunert";
    extraGroups = [
      "audio"
      "kvm"
      "libvirtd"
      "networkmanager"
      "video"
      "wheel"
    ];
    shell = pkgs.fish;
  };
}
