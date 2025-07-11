{
  config,
  lib,
  self,
  ...
}: {
  options.myNixOS.profiles.wifi.enable = lib.mkEnableOption "wifi configuration";

  config = lib.mkIf config.myNixOS.profiles.wifi.enable {
    age.secrets.wifi.file = "${self.inputs.secrets}/wifi.age";

    networking.networkmanager = {
      enable = true;

      ensureProfiles = {
        environmentFiles = [config.age.secrets.wifi.path];

        profiles = let
          mkOpenWiFi = ssid: {
            connection.id = "${ssid}";
            connection.type = "wifi";
            ipv4.method = "auto";
            ipv6.addr-gen-mode = "default";
            ipv6.method = "auto";
            wifi.mode = "infrastructure";
            wifi.ssid = "${ssid}";
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
              "802-1x".eap = "peap;";
              "802-1x".identity = "${identity}";
              "802-1x".password = "${pass}";
              "802-1x".phase2-auth = "${auth}";
              wifi-security.auth-alg = "open";
              wifi-security.key-mgmt = "wpa-eap";
            }
          );
        in {
          "Atolls_Atlanta" = mkWPA2WiFi "Atolls_Atlanta" "$Atolls_AtlantaPSK";
          "DevonCorp" = mkWPA2WiFi "DevonCorp" "$DevonCorpPSK";
          "Dustin's A54" = mkWPA2WiFi "Dustin's A54" "$DustinsA54PSK";
          "East Pole Coffee Co." = mkWPA2WiFi "East Pole Coffee Co." "$EastPolePSK";
          "InmanPerkCustomer" = mkWPA2WiFi "InmanPerkCustomer" "$InmanPerkCustomerPSK";
          "LilycoveDeptStore" = mkWPA2WiFi "LilycoveDeptStore" "$LilycoveDeptStorePSK";
          "Muchacho Guest" = mkOpenWiFi "Muchacho Guest";
          "MOTO4A8E-5G" = mkWPA2WiFi "MOTO4A8E-5G" "$MOTO4A8EPSK";
          "norman" = mkWPA2WiFi "norman" "$normanPSK";
          "Oakview Coffee Wi-Fi" = mkWPA2WiFi "Oakview Coffee Wi-Fi" "$OakviewCoffeeWiFiPSK";
          "Parkgrounds1" = mkWPA2WiFi "Parkgrounds1" "$Parkgrounds1PSK";
          "PERC COFFEE 5 Guest" = mkWPA2WiFi "PERC COFFEE 5 Guest" "$PERCguestPSK";
          "PERCguest" = mkWPA2WiFi "PERCguest" "$PERCguestPSK";
          "SELF-public" = mkWPA2WiFi "SELF-public" "$SELFpublicPSK";
          "VINATL-Guest" = mkWPA2WiFi "VINATL-Guest" "$VINATLGuestPSK";
          "WeWorkWiFi" = mkEAPWiFi "WeWorkWiFi" "$WeWorkWiFiIdentity" "$WeWorkWiFiPassword" "mschapv2";
        };
      };

      wifi.powersave = true;
    };
  };
}
