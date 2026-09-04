{ pkgs, ... }:
{
  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      plugins = [ pkgs.networkmanager-openvpn ];
      wifi.powersave = false;
    };
    firewall.allowedTCPPorts = [ 22 ];
  };

  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSSEC = "allow-downgrade";
      DNSOverTLS = false;
    };
  };
}
