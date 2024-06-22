{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [./sambaAutoMount.nix];
  config = lib.mkIf config.alyraffauf.base.enable {
    age.secrets.wifi.file = ../../../secrets/wifi.age;

    hardware = {
      bluetooth.enable = true;
    };

    networking.networkmanager = {
      enable = true;

      ensureProfiles = {
        environmentFiles = [
          config.age.secrets.wifi.path
        ];
        profiles = {
          "Dustin's A54" = {
            connection = {
              id = "Dustin's A54";
              type = "wifi";
              uuid = "fc221cbd-b6fd-44e0-8679-5998933b2fff";
            };
            wifi.ssid = "Dustin's A54";
            wifi-security = {
              auth-alg = "open";
              key-mgmt = "wpa-psk";
              psk = "$DustinsA54PSK";
            };
          };

          javapatron = {
            connection = {
              id = "javapatron";
              type = "wifi";
              uuid = "bb61beaa-ec07-404c-bbce-5a08ae355de7";
            };
            wifi.ssid = "javapatron";
            wifi-security = {
              auth-alg = "open";
              key-mgmt = "wpa-psk";
            };
          };

          "Taproom Public WiFi" = {
            connection = {
              id = "Taproom Public WiFi";
              type = "wifi";
              uuid = "d79280e9-4a22-4125-9583-eb7b80abfeb6";
            };
            wifi.ssid = "Taproom Public WiFi";
            wifi-security = {
              auth-alg = "open";
              key-mgmt = "wpa-psk";
            };
          };

          Stargate-Discovery = {
            connection = {
              id = "Stargate-Discovery";
              type = "wifi";
            };
            wifi.ssid = "Stargate-Discovery";
            wifi-security = {
              auth-alg = "open";
              key-mgmt = "wpa-psk";
              psk = "$StargateDiscoveryPSK";
            };
          };

          wallace = {
            connection = {
              id = "wallace";
              type = "wifi";
              uuid = "6896b13d-9717-4a8d-8a08-2a97139bf833";
            };
            wifi.ssid = "wallace";
            wifi-security = {
              auth-alg = "open";
              key-mgmt = "wpa-psk";
              psk = "$wallacePSK";
            };
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
            wifi.ssid = "WeWorkWiFi";
            wifi-security.key-mgmt = "wpa-eap";
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
