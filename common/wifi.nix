{config, ...}: let
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
      wifi-security.auth-alg = "open";
      wifi-security.key-mgmt = "wpa-psk";
      wifi-security.psk = "${psk}";
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
  age.secrets.wifi.file = ../secrets/wifi.age;

  networking.networkmanager = {
    enable = true;

    ensureProfiles = {
      environmentFiles = [config.age.secrets.wifi.path];
      profiles = {
        "Dustin's A54" = mkWPA2WiFi "Dustin's A54" "$DustinsA54PSK";
        "InmanPerkCustomer" = mkWPA2WiFi "InmanPerkCustomer" "$InmanPerkCustomerPSK";
        "Muchacho Guest" = mkOpenWiFi "Muchacho Guest";
        "Parkgrounds1" = mkWPA2WiFi "Parkgrounds1" "$Parkgrounds1PSK";
        "Stargate-Discovery" = mkWPA2WiFi "Stargate-Discovery" "$StargateDiscoveryPSK";
        "Taproom Public WiFi" = mkOpenWiFi "Taproom Public WiFi";
        "WeWorkWiFi" = mkEAPWiFi "WeWorkWiFi" "$WeWorkWiFiIdentity" "$WeWorkWiFiPassword" "mschapv2";
        "javapatron" = mkOpenWiFi "javapatron";
        "wallace" = mkWPA2WiFi "wallace" "$wallacePSK";
      };
    };
  };
}
