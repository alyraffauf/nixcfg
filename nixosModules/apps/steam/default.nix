{
  config,
  lib,
  pkgs,
  ...
}: {
  config =
    lib.mkIf (
      config.ar.apps.steam.enable
      || config.ar.desktop.steam.enable
    ) {
      hardware.steam-hardware.enable = true;

      programs = {
        gamescope.enable = config.ar.desktop.steam.enable;

        steam = {
          enable = true;
          dedicatedServer.openFirewall = true;
          extest.enable = true;
          extraCompatPackages = with pkgs; [proton-ge-bin];
          gamescopeSession.enable = config.ar.desktop.steam.enable;
          localNetworkGameTransfers.openFirewall = true;
          remotePlay.openFirewall = true;
        };
      };
    };
}
