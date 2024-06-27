{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.ar.apps.steam.enable {
    programs = {
      gamescope.enable = config.ar.desktop.steam.enable;

      steam = {
        enable = true;
        dedicatedServer.openFirewall = true;
        extraCompatPackages = with pkgs; [proton-ge-bin];
        gamescopeSession.enable = config.ar.desktop.steam.enable;
        localNetworkGameTransfers.openFirewall = true;
        remotePlay.openFirewall = true;
      };
    };
  };
}
