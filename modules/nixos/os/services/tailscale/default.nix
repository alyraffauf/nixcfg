{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myNixOS.services.tailscale = {
    enable = lib.mkEnableOption "Tailscale VPN service";

    authKeyFile = lib.mkOption {
      description = "Key file to use for authentication";
      default = config.age.secrets.tailscaleAuthKey.path or null;
      type = lib.types.nullOr lib.types.path;
    };

    enableCaddy = lib.mkOption {
      description = "Whether to serve supported local services on Tailnet with Caddy.";
      default = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf config.myNixOS.services.tailscale.enable {
    assertions = [
      {
        assertion = config.myNixOS.services.tailscale.authKeyFile != null;
        message = "config.tailscale.authKeyFile cannot be null.";
      }
    ];

    home-manager.sharedModules = [
      {
        programs.gnome-shell.extensions = [
          {package = pkgs.gnomeExtensions.tailscale-status;}
        ];
      }
    ];

    networking.firewall = {
      allowedUDPPorts = [config.services.tailscale.port];
      trustedInterfaces = [config.services.tailscale.interfaceName];
    };

    services = {
      caddy = lib.mkIf config.myNixOS.services.tailscale.enableCaddy {
        enable = true;

        virtualHosts."${config.networking.hostName}.${config.mySnippets.tailnet}".extraConfig = let
          jellyfin = ''
            redir /jellyfin /jellyfin/
            handle_path /jellyfin/* {
              reverse_proxy localhost:${toString 8096}
            }
          '';

          qbittorrent = ''
            redir /qbittorrent /qbittorrent/
            handle_path /qbittorrent/* {
              reverse_proxy localhost:${toString config.myNixOS.services.qbittorrent.port}
            }
          '';

          syncthing = ''
            redir /syncthing /syncthing/
            handle_path /syncthing/* {
              reverse_proxy localhost:8384 {
                header_up Host localhost
              }
            }
          '';
        in
          lib.concatLines (
            lib.optional (config.services.jellyfin.enable)
            jellyfin
            ++ lib.optional (config.myNixOS.services.qbittorrent.enable) qbittorrent
            ++ lib.optional (config.services.syncthing.enable) syncthing
          );
      };

      tailscale = {
        enable = true;
        authKeyFile = config.myNixOS.services.tailscale.authKeyFile;
        extraUpFlags = ["--ssh"];
        openFirewall = true;
        permitCertUid = lib.mkIf (config.services.caddy.enable) "caddy";
        useRoutingFeatures = "both";
      };
    };
  };
}
