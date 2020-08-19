{ config, lib, pkgs, ... }:
{
  environment.etc = {
    "apparmor/parser.conf".text = "";

    "cni/net.d/10-crio-bridge.conf".text = ''
      {
        "cniVersion": "0.3.1",
        "name": "crio",
        "type": "bridge",
        "bridge": "cni0",
        "isGateway": true,
        "ipMasq": true,
        "hairpinMode": true,
        "ipam": {
          "type": "host-local",
          "routes": [
            { "dst": "0.0.0.0/0" },
            { "dst": "1100:200::1/24" }
          ],
          "ranges": [
            [{ "subnet": "10.85.0.0/16" }],
            [{ "subnet": "1100:200::/24" }]
          ]
        }
      }
    '';

    "cni/net.d/99-loopback.conf".text = ''
      { "cniVersion": "0.3.1", "type": "loopback" }
    '';

    "crictl.yaml".text = ''
      runtime-endpoint: unix:///var/run/crio/crio.sock
    '';
  };
}
