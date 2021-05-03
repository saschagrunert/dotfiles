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
