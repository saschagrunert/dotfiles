{ pkgs, username, ... }:
{
  users.users.${username} = {
    isNormalUser = true;
    description = "Sascha Grunert";
    extraGroups = [
      "audio"
      "kvm"
      "libvirtd"
      "networkmanager"
      "podman"
      "video"
      "wheel"
    ];
    shell = pkgs.fish;
  };
}
