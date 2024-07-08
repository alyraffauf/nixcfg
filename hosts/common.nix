{
  config,
  lib,
  pkgs,
  ...
}: {
  age.secrets = {
    tailscaleAuthKey.file = ../secrets/tailscale/authKeyFile.age;
    wifi.file = ../secrets/wifi.age;
  };

  environment.variables.FLAKE = "github:alyraffauf/nixcfg";

  fileSystems = lib.attrsets.optionalAttrs (config.networking.hostName != "mauville") {
    "/mnt/Archive" = {
      device = "//mauville/Archive";
      fsType = "cifs";
      options = [
        "gid=100"
        "guest"
        "nofail"
        "uid=${toString config.users.users.aly.uid}"
        "x-systemd.after=network.target"
        "x-systemd.after=tailscaled.service"
        "x-systemd.automount"
        "x-systemd.device-timeout=5s"
        "x-systemd.idle-timeout=60"
        "x-systemd.mount-timeout=5s"
      ];
    };

    "/mnt/Media" = {
      device = "//mauville/Media";
      fsType = "cifs";
      options = [
        "gid=100"
        "guest"
        "nofail"
        "uid=${toString config.users.users.aly.uid}"
        "x-systemd.after=network.target"
        "x-systemd.after=tailscaled.service"
        "x-systemd.automount"
        "x-systemd.device-timeout=5s"
        "x-systemd.idle-timeout=60"
        "x-systemd.mount-timeout=5s"
      ];
    };
  };

  home-manager.sharedModules = [
    {
      gtk.gtk3.bookmarks = lib.optionals (config.networking.hostName != "mauville") [
        "file:///mnt/Media"
        "file:///mnt/Archive"
      ];
    }
  ];

  nix.settings.trusted-users = ["aly"];

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

  services.tailscale = {
    enable = true;
    openFirewall = true;
    authKeyFile = config.age.secrets.tailscaleAuthKey.path;
  };
}
