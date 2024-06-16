{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.apps.steam.enable {
    hardware.steam-hardware.enable = true;
    programs = {
      gamescope.enable = config.alyraffauf.desktop.steam.enable;

      steam = {
        enable = true;
        dedicatedServer.openFirewall = true;
        gamescopeSession.enable = config.alyraffauf.desktop.steam.enable;
        localNetworkGameTransfers.openFirewall = true;
        remotePlay.openFirewall = true;
      };
    };
  };
}
