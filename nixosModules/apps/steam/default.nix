{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.apps.steam.enable {
    hardware.steam-hardware.enable = true;
    programs = {
      gamescope.enable = true;
      steam = {
        enable = true;
        gamescopeSession.enable = true;
        remotePlay.openFirewall =
          true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall =
          true; # Open ports in the firewall for Source Dedicated Server
      };
    };
  };
}
