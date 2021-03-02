{ config, lib, pkgs, ... }:
{
  security = {
    apparmor.enable = true;
    audit.enable = true;
    auditd.enable = true;
    pki.certificateFiles = [ /etc/pki/tls/certs/2015-RH-IT-Root-CA.pem ];
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };

  environment.etc = {
    "audit/auditd.conf".text = ''
      disp_qos = lossy
      #dispatcher = ${pkgs.audit}/bin/audispd
      flush = INCREMENTAL_ASYNC
      freq = 50
      local_events = yes
      log_file = /var/log/audit/audit.log
      log_format = RAW
      log_group = adm
      max_log_file = 8
      max_log_file_action = ROTATE
      name_format = NONE
      num_logs = 5
      priority_boost = 4
      space_left = 75
      space_left_action = SYSLOG
      write_logs = yes
    '';
  };
}
