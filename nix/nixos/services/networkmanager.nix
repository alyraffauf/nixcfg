{self, ...}: {
  flake.nixosModules.default = {config, ...}: {
    sops.secrets.lilycove-dept-store-wifi = {
      key = "environment";
      sopsFile = self + "/secrets/wifi.yaml";
    };

    networking.networkmanager = {
      enable = true;

      ensureProfiles = {
        environmentFiles = [config.sops.secrets.lilycove-dept-store-wifi.path];

        profiles.LilycoveDeptStore = {
          connection = {
            id = "LilycoveDeptStore";
            type = "wifi";
          };

          ipv4.method = "auto";

          ipv6 = {
            addr-gen-mode = "default";
            method = "auto";
          };

          wifi = {
            mode = "infrastructure";
            ssid = "LilycoveDeptStore";
          };

          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$LilycoveDeptStorePSK";
          };
        };
      };
    };
  };
}
