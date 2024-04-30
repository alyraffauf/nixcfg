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
    services.tailscale = {
      enable = true;
      openFirewall = true;
    };
  };
}
