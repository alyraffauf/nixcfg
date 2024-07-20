let
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
  "Dustin's A54" = mkWPA2WiFi "Dustin's A54" "$DustinsA54PSK";
  "FCS-WiFi2" = mkEAPWiFi "FCS-WiFi2" "$FCSIdentity" "$FCSPassword" "mschapv2";
  "javapatron" = mkOpenWiFi "javapatron";
  "Stargate-Discovery" = mkWPA2WiFi "Stargate-Discovery" "$StargateDiscoveryPSK";
  "Taproom Public WiFi" = mkOpenWiFi "Taproom Public WiFi";
  "wallace" = mkWPA2WiFi "wallace" "$wallacePSK";
  "WeWorkWiFi" = mkEAPWiFi "WeWorkWiFi" "$WeWorkWiFiIdentity" "$WeWorkWiFiPassword" "mschapv2";
}
