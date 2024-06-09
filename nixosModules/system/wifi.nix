{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  age.secrets.wifi.file = ../../secrets/wifi.age;

  networking.networkmanager = {
    ensureProfiles = {
      environmentFiles = [
        config.age.secrets.wifi.path
      ];
      profiles = {
        Stargate-Discovery = {
          connection.type = "wifi";
          connection.id = "Stargate-Discovery";
          wifi.ssid = "Stargate-Discovery";
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$StargateDiscoveryPSK";
          };
        };
        wattson = {
          connection.type = "wifi";
          connection.id = "wattson";
          wifi.ssid = "wattson";
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$wattsonPSK";
          };
        };
        "Dustin’s iPhone" = {
          connection.type = "Dustin’s iPhone";
          connection.id = "Dustin’s iPhone";
          wifi.ssid = "Dustin’s iPhone";
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$DustinsiPhonePSK";
          };
        };
      };
    };
  };
}
