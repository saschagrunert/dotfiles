_:
{
  security = {
    krb5 = {
      enable = true;
      settings = {
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
    };
    pki.certificateFiles = [ ./2022-IT-Root-CA.pem ];
    sudo.wheelNeedsPassword = false;
    sudo.execWheelOnly = true;
  };
}
