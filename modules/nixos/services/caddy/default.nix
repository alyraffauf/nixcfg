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
      caddy = {
        enable = true;
        enableReload = false;
        environmentFile = config.age.secrets.tailscaleCaddyAuth.path;

        globalConfig = ''
          tailscale {
            ephemeral true
          }
        '';

        package = pkgs.caddy.withPlugins {
          plugins = ["github.com/tailscale/caddy-tailscale@v0.0.0-20250508175905-642f61fea3cc"];
          hash = "sha256-Ii5u/erVBidyz4Ng7uKky9H2HPwxDunWBPXoxmJ2i4A=";
        };
      };

      tailscale.permitCertUid = "caddy";
    };
  };
}
