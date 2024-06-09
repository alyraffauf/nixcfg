{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.agenix.nixosModules.default
  ];

  age.secrets.Stargate-Discovery.file = ../../secrets/wifi/Stargate-Discovery.age;
  age.secrets.wattson.file = ../../secrets/wifi/wattson.age;

  networking.networkmanager = {
    ensureProfiles = {
      environmentFiles = [
        config.age.secrets.Stargate-Discovery.path
        config.age.secrets.wattson.path
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
      };
    };
  };
}
