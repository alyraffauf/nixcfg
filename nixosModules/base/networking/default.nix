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

        profiles = let
          mkOpenWiFi = ssid: {
            connection = {
              id = "${ssid}";
              type = "wifi";
            };

            ipv4.method = "auto";

            ipv6 = {
              addr-gen-mode = "default";
              method = "auto";
            };

            wifi = {
              mode = "infrastructure";
              ssid = "${ssid}";
            };
          };

          mkWPA2WiFi = ssid: psk: (
            (mkOpenWiFi ssid)
            // {
              wifi-security = {
                auth-alg = "open";
                key-mgmt = "wpa-psk";
                psk = "${psk}";
              };
            }
          );

          mkEAPWiFi = ssid: identity: pass: auth: (
            (mkOpenWiFi ssid)
            // {
              "802-1x" = {
                eap = "peap;";
                identity = "${identity}";
                password = "${pass}";
                phase2-auth = "${auth}";
              };

              wifi-security = {
                auth-alg = "open";
                key-mgmt = "wpa-eap";
              };
            }
          );
        in {
          "Dustin's A54" = mkWPA2WiFi "Dustin's A54" "$DustinsA54PSK";
          "FCS-WiFi2" = mkEAPWiFi "FCS-WiFi2" "$FCSIdentity" "$FCSPassword" "mschapv2";
          "javapatron" = mkOpenWiFi "javapatron";
          "Stargate-Discovery" = mkWPA2WiFi "Stargate-Discovery" "$StargateDiscoveryPSK";
          "Taproom Public WiFi" = mkOpenWiFi "Taproom Public WiFi";
          "wallace" = mkWPA2WiFi "wallace" "$wallacePSK";
          "WeWorkWiFi" = mkEAPWiFi "WeWorkWiFi" "$WeWorkWiFiIdentity" "$WeWorkWiFiPassword" "mschapv2";
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

      system-config-printer.enable = true;
    };
  };
}
