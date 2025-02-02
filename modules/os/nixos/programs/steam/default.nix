{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myNixOS.programs.steam = {
    enable = lib.mkEnableOption "Steam client configuration";
    session.enable = lib.mkEnableOption "Steam + Gamescope desktop session";
  };

  config = lib.mkIf config.myNixOS.programs.steam.enable {
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
        gamescopeSession.enable = config.myNixOS.programs.steam.session.enable;
        localNetworkGameTransfers.openFirewall = true;
        remotePlay.openFirewall = true;
      };
    };
  };
}
