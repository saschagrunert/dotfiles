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

    # Declared here so the keys that make the enabled sshd usable are part of
    # the configuration instead of being managed out of band.
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDXmKbxf5NP9aFYeDrveWS0yruQh9lqOLeKzrmlnHMmOBn8vc93Gby2I1H8qkF662+bO97OukmQMIuNYrwbUkSX0m/FUzknPkZHC8sKK1swWfmckYc6S2oTEiA83BAjcFQO0fkF6tXK5lFzFpaUw9ghNC3aRygMks6OXb9GMzVbBvY58taeOoU3vnmLXO2uIED81fm4wdl2QGTEDC2v38cqMDzgtbp28gdp3H8qDM+5u1iO77utO8Zn7zNQSk3BZjEit6NR4Ny+Hd2s2ZVUk5vSM1t3/xC5st4K+DeLSYaQOq+or6Gv2tPriOZozbLoWRYOUX/p3BbF8c7CvjFMkTkT"
    ];
  };
}
