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
          wattson = {
            connection = {
              id = "wattson";
              type = "wifi";
            };
            wifi.ssid = "wattson";
            wifi-security = {
              auth-alg = "open";
              key-mgmt = "wpa-psk";
              psk = "$wattsonPSK";
            };
          };
          "Dustin’s iPhone" = {
            connection = {
              id = "Dustin’s iPhone";
              type = "wifi";
            };
            wifi.ssid = "Dustin’s iPhone";
            wifi-security = {
              auth-alg = "open";
              key-mgmt = "wpa-psk";
              psk = "$DustinsiPhonePSK";
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
      };

      printing.enable = true;
    };
  };
}
