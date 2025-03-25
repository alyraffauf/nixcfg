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

    services.tailscale = {
      enable = true;
      authKeyFile = config.myNixOS.services.tailscale.authKeyFile;
      extraUpFlags = ["--ssh"];
      openFirewall = true;
      useRoutingFeatures = "both";
    };
  };
}
