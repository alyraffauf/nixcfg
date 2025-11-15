{
  config,
  lib,
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

    operator = lib.mkOption {
      description = "Tailscale operator name";
      default = null;
      type = lib.types.nullOr lib.types.str;
    };
  };

  config = lib.mkIf config.myNixOS.services.tailscale.enable {
    assertions = [
      {
        assertion = config.myNixOS.services.tailscale.authKeyFile != null;
        message = "config.tailscale.authKeyFile cannot be null.";
      }
    ];

    networking.firewall = {
      allowedUDPPorts = [config.services.tailscale.port];
      trustedInterfaces = [config.services.tailscale.interfaceName];
    };

    services.tailscale = {
      enable = true;
      inherit (config.myNixOS.services.tailscale) authKeyFile;

      extraUpFlags =
        ["--ssh"]
        ++ lib.optional (config.myNixOS.services.tailscale.operator != null)
        "--operator ${config.myNixOS.services.tailscale.operator}";

      openFirewall = true;
      useRoutingFeatures = "both";
    };

    myNixOS.programs.njust.recipes.tailscale = ''
      # Connect to Mullvad NYC
      [group('tailscale')]
      enable-mullvad:
          @echo "Connecting to Mullvad NYC exit node..."
          tailscale set --exit-node=us-nyc-wg-301.mullvad.ts.net

      # Disconnect from Mullvad NYC
      [group('tailscale')]
      disable-mullvad:
          @echo "Disconnecting from exit node..."
          tailscale set --exit-node=

      # Show Tailscale status
      [group('tailscale')]
      ts-status:
          tailscale status
    '';
  };
}
