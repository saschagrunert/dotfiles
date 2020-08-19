{ config, lib, pkgs, ... }:
{
  security = {
    apparmor.enable = true;
    audit.enable = true;
    auditd.enable = true;
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };
}
