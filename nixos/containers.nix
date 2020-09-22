{ config, lib, pkgs, ... }:
{
  environment.etc = {
    "containers/registries.d/default.yaml".text = ''
      default-docker:
        sigstore-staging: file:///var/lib/containers/sigstore
    '';
    "containers/registries.d/suse.yaml".text = ''
      docker:
        registry.opensuse.org:
          sigstore: https://registry.opensuse.org/sigstore
        registry.suse.com:
          sigstore: https://registry.suse.com/sigstore
    '';
    "containers/keys/opensuse.asc".text = ''
    '';
    "containers/keys/suse.asc".text = ''
    '';
  };
  virtualisation.containers.policy =
    {
      default = [{ type = "insecureAcceptAnything"; }];
      transports = {
        docker-daemon = {
          "" = [{ type = "insecureAcceptAnything"; }];
        };
        docker = {
          "registry.opensuse.org" = [
            {
              type = "signedBy";
              keyType = "GPGKeys";
              keyPath = "/etc/containers/keys/opensuse.asc";
            }
          ];
          "registry.suse.com" = [
            {
              type = "signedBy";
              keyType = "GPGKeys";
              keyPath = "/etc/containers/keys/suse.asc";
            }
          ];
        };
      };
    };
}
