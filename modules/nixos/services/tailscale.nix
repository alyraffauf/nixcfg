{
  config,
  lib,
  ...
}: {
  options.tailscale.authKeyFile = lib.mkOption {
    description = "User to autologin.";
    default = config.age.secrets.tailscaleAuthKey.path or null;
    type = lib.types.nullOr lib.types.path;
  };

  config = {
    assertions = [
      {
        assertion = config.tailscale.authKeyFile != null;
        message = "config.tailscale.authKeyFile cannot be null.";
      }
    ];

    networking.firewall = {
      allowedUDPPorts = [config.services.tailscale.port];
      trustedInterfaces = [config.services.tailscale.interfaceName];
    };

    services.tailscale = {
      enable = true;
      authKeyFile = config.tailscale.authKeyFile;
      openFirewall = true;
    };
  };
}
