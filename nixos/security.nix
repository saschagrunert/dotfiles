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

  environment.etc = {
    "audit/auditd.conf".text = ''
      local_events = yes
      write_logs = yes
      log_file = /var/log/audit/audit.log
      log_group = adm
      log_format = RAW
      flush = INCREMENTAL_ASYNC
      freq = 50
      max_log_file = 8
      num_logs = 5
      priority_boost = 4
      disp_qos = lossy
      name_format = NONE
      max_log_file_action = ROTATE
      space_left = 75
      space_left_action = SYSLOG
    '';
  };
}
