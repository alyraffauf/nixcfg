{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.services.tailscale.enable = lib.mkEnableOption "Enable Tailscale";
  };

  config = lib.mkIf config.alyraffauf.services.tailscale.enable {
    age.secrets.tailscaleAuthKey.file = ../../../secrets/tailscale/authKeyFile.age;
    services.tailscale = {
      enable = true;
      openFirewall = true;
      authKeyFile = config.age.secrets.tailscaleAuthKey.path;
    };
  };
}
