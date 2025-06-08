{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  options.myNixOS.services.caddy.enable = lib.mkEnableOption "Caddy web server.";

  config = lib.mkIf config.myNixOS.services.caddy.enable {
    age.secrets.tailscaleCaddyAuth.file = "${self.inputs.secrets}/tailscale/caddyAuth.age";
    networking.firewall.allowedTCPPorts = [80 443];

    services = {
      caddy = lib.mkIf config.myNixOS.services.tailscale.enableCaddy {
        enable = true;
        environmentFile = config.age.secrets.tailscaleCaddyAuth.path;

        globalConfig = ''
          tailscale {
            ephemeral true
          }
        '';

        package = pkgs.caddy.withPlugins {
          plugins = ["github.com/tailscale/caddy-tailscale@v0.0.0-20250508175905-642f61fea3cc"];
          hash = "sha256-Kbqr7spiL8/UvT0HtCm0Ufh5Nm1VYDjyNWPCd1Yxyxc=";
        };

        virtualHosts = {
          "${config.networking.hostName}.${config.mySnippets.tailnet}".extraConfig = let
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
              lib.optional (config.myNixOS.services.qbittorrent.enable) qbittorrent
              ++ lib.optional (config.services.syncthing.enable) syncthing
            );
        };
      };

      tailscale.permitCertUid = "caddy";
    };
  };
}
