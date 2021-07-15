{ config, lib, pkgs, ... }:
{
  krb5 = {
    enable = true;
    libdefaults = {
      default_realm = "IPA.REDHAT.COM";
      dns_lookup_realm = true;
      dns_lookup_kdc = true;
      rdns = false;
      dns_canonicalize_hostname = true;
      ticket_lifetime = "24h";
      forwardable = true;
      udp_preference_limit = 0;
      default_ccache_name = "KEYRING:persistent:%{uid}";
    };
    realms = {
      "REDHAT.COM" = {
        default_domain = "redhat.com";
        dns_lookup_kdc = true;
        master_kdc = "kerberos.corp.redhat.com";
        admin_server = "kerberos.corp.redhat.com";
      };
      "IPA.REDHAT.COM" = {
        pkinit_anchors = "FILE:/etc/ipa/ca.crt";
        pkinit_pool = "FILE:/etc/ipa/ca.crt";
        default_domain = "ipa.redhat.com";
        dns_lookup_kdc = true;
        auth_to_local = ''RULE:[1:$1@$0](.*@REDHAT\.COM)s/@.*//'';
      };
    };
  };

  security = {
    audit.enable = true;
    auditd.enable = true;
    pki.certificateFiles = [ /etc/pki/tls/certs/2015-RH-IT-Root-CA.pem ];
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };

  environment.etc = {
    "audit/audit.rules".text = ''
      -D

      -a task,never
    '';
    "audit/auditd.conf".text = ''
      local_events = yes
      write_logs = yes
      log_file = /var/log/audit/audit.log
      log_group = wheel
      log_format = ENRICHED
      flush = INCREMENTAL_ASYNC
      freq = 50
      max_log_file = 8
      num_logs = 5
      priority_boost = 4
      name_format = NONE
      max_log_file_action = ROTATE
      space_left = 75
      space_left_action = SYSLOG
      verify_email = yes
      action_mail_acct = root
      admin_space_left = 50
      admin_space_left_action = SUSPEND
      disk_full_action = SUSPEND
      disk_error_action = SUSPEND
      use_libwrap = yes
      tcp_listen_queue = 5
      tcp_max_per_addr = 1
      tcp_client_max_idle = 0
      distribute_network = no
    '';
  };
}
