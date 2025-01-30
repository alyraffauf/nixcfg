{
  config,
  lib,
  pkgs,
  ...
}: {
  options.steam.session.enable = lib.mkEnableOption "Steam + Gamescope desktop session.";

  config = {
    environment.sessionVariables = {
      # STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = lib.makeSearchPathOutput "steamcompattool" "" config.programs.steam.extraCompatPackages;
    };

    hardware.steam-hardware.enable = true;

    programs = {
      gamescope.enable = true;

      steam = {
        enable = true;
        dedicatedServer.openFirewall = true;
        extest.enable = true;
        extraCompatPackages = with pkgs; [proton-ge-bin];
        gamescopeSession.enable = config.steam.session.enable;
        localNetworkGameTransfers.openFirewall = true;
        remotePlay.openFirewall = true;
      };
    };
  };
}
