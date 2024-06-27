{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [./sambaAutoMount.nix];
  config = lib.mkIf config.ar.base.enable {
    age.secrets.wifi.file = ../../../secrets/wifi.age;

    networking.networkmanager = {
      enable = true;

      ensureProfiles = {
        environmentFiles = [config.age.secrets.wifi.path];

        profiles = {
          "Dustin's A54" = {
            connection = {
              id = "Dustin's A54";
              type = "wifi";
              uuid = "fc221cbd-b6fd-44e0-8679-5998933b2fff";
            };

            wifi-security = {
              auth-alg = "open";
              key-mgmt = "wpa-psk";
              psk = "$DustinsA54PSK";
            };

            wifi.ssid = "Dustin's A54";
          };

          javapatron = {
            connection = {
              id = "javapatron";
              type = "wifi";
              uuid = "bb61beaa-ec07-404c-bbce-5a08ae355de7";
            };

            wifi-security = {
              auth-alg = "open";
              key-mgmt = "wpa-psk";
            };

            wifi.ssid = "javapatron";
          };

          "Taproom Public WiFi" = {
            connection = {
              id = "Taproom Public WiFi";
              type = "wifi";
              uuid = "d79280e9-4a22-4125-9583-eb7b80abfeb6";
            };

            wifi-security = {
              auth-alg = "open";
              key-mgmt = "wpa-psk";
            };

            wifi.ssid = "Taproom Public WiFi";
          };

          Stargate-Discovery = {
            connection = {
              id = "Stargate-Discovery";
              type = "wifi";
            };

            wifi-security = {
              auth-alg = "open";
              key-mgmt = "wpa-psk";
              psk = "$StargateDiscoveryPSK";
            };

            wifi.ssid = "Stargate-Discovery";
          };

          wallace = {
            connection = {
              id = "wallace";
              type = "wifi";
              uuid = "6896b13d-9717-4a8d-8a08-2a97139bf833";
            };

            wifi-security = {
              auth-alg = "open";
              key-mgmt = "wpa-psk";
              psk = "$wallacePSK";
            };

            wifi.ssid = "wallace";
          };

          WeWorkWiFi = {
            "802-1x" = {
              eap = "peap;";
              identity = "$WeWorkWiFiIdentity";
              password = "$WeWorkWiFiPassword";
              phase2-auth = "mschapv2";
            };

            connection = {
              id = "WeWorkWiFi";
              type = "wifi";
            };

            wifi-security.key-mgmt = "wpa-eap";
            wifi.ssid = "WeWorkWiFi";
          };
        };
      };
    };

    services = {
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
        publish = {
          enable = true;
          addresses = true;
          userServices = true;
          workstation = true;
        };
      };

      openssh = {
        enable = true;
        openFirewall = true;
        settings.PasswordAuthentication = false;
      };

      printing.enable = true;
    };
  };
}
