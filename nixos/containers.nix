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
      -----BEGIN PGP PUBLIC KEY BLOCK-----
      Version: GnuPG v2.0.15 (GNU/Linux)

      mQENBFrjEWoBCADEJttox1LVpcP2YIsLIO5qKmwfMhyjSQ+L4ETztnFRLKFIlin4
      19Tic/llF9ymQr2MxlKlRgdzFZ9ScH1rg52bmWdxy+2TZ8JIsSV4XyfSTZJvM+nX
      YGxEQBJrYlcRfC5he0tBGTEwG+hp6kXH563F+XU4uzGUmh1rBhavDsWjeMo9sjaf
      sqn66JAJnxJrQOcqjNvazYjppEjFzye/Haqu2r5cnD/bPnMvQEZtpN1jznWkIha2
      DdapVZq2b/SmdTMV7zHRqQvhERU2uS4SFLNopyt/cwujj3XTWqCArvQgRTaiHAiL
      4HY3lUpDWH9pmxT+yu5f7FINc+prRmvnQ1YpABEBAAG0PW9wZW5TVVNFIENvbnRh
      aW5lciBTaWduaW5nIEtleSA8YnVpbGQtY29udGFpbmVyQG9wZW5zdXNlLm9yZz6J
      AT4EEwECACgFAlrjEWoCGwMFCRLMAwAGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheA
      AAoJENdUaU+atIzpdt0H/A5j9B7feqTRK49TWIsgKTELG+6ac4WL+uvZs4HmUPgO
      Me9fkQvmJtPMGQT3awCSejEHuvq7sMsOOAXJ3loVDNkJWOtkohRyJf6++lvzL24v
      ApbzSLfxa1intscyoJ0g8A2V+NzG428cMAzL5Rnf1ckimDkwOgjFBTDqwq1nPFDQ
      +01wAenDPLduLAS65+urmMEOIhoBB3Opc5fqPKWU+w8qav8YfYUjaQcAfGeswt+6
      m54VXYk8prmCuSfFHq9Yi8T2+VMcIEdHQYOn4nVhzNY9mTzJ4CCGYdLhap4/P8/x
      HuiUuVrARHeCoTiQSc1FwjT1QXaU+yYk1SLFi0LaPgQ=
      =Klfs
      -----END PGP PUBLIC KEY BLOCK-----
    '';
    "containers/keys/suse.asc".text = ''
      -----BEGIN PGP PUBLIC KEY BLOCK-----
      Version: GnuPG v2.0.15 (GNU/Linux)

      mQENBFoulmkBCAC8z90eiLqdLLuFsocthStfLoG/fklt2gjOfLm9IWJFcCmvQpLn
      pTw+6B0aaH693sfxg2XHZg4nHO/TYGWytyZYNlxeMTdemyL8gcV9Fks53DBH67ww
      0XHBFRXPHIjMoa1tERVV9c99vZdzoUvn+0S9C1Qq5Hpd3NJpq/ZGdXkjJsIHT2zQ
      2nQBRt2LkR9J7gg26qBj5UVguO8zmidsBAs3dsUtLhC6TroOG/3dmLo3CinAvUXT
      tQ8Lm5p2TJ49K0/c8DQ4A56aP29kAM5bHlp2wYIohKzyKmE0LmYNWgvLxHLj0yzd
      5BdGNVA4xyjdg1/wCGwh3EM0FU3xVMMpWQQPABEBAAG0OlNVU0UgTGludXggQ29u
      dGFpbmVyIFNpZ25pbmcgS2V5IDxidWlsZC1jb250YWluZXJAc3VzZS5kZT6JAT4E
      EwECACgFAloulmkCGwMFCRLMAwAGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAAoJ
      EI7+G8TUrenDlswH/1PwQuV0Um6J5csZIcde25Ip/LJMoldJb9aVpBxn70WWL6GF
      AVoVTNFYYPHUbzv9/x2PPLRy2tcta+YZOKvcFbkM2SHXz1KF95Lg50pDr++DWog+
      SDszvq3oVeIt3OIqvL1gbmp3V13qPLboFR+q3jMqMxUh9bYQX3rpH/cWq7h8yurL
      KaiR9yQvHaPSrcGuJUGTr2zbEPBYCoMnEPuF/fNjwaTHmEX2fzoYhmIOZMH5x5W+
      F1GOCZrK34QrdHuS+LmpV8mQz0+Qpd7LOGcd8wF3K2ep5xiwpOdzBELiekZaxrJ1
      o0UviorRX4DPHLXZvyqPCCpYLWzj9b7rHCuenoQ=
      =BucV
      -----END PGP PUBLIC KEY BLOCK-----
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
