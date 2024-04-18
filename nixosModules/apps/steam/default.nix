{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.apps.steam.enable = lib.mkEnableOption "Enables Steam for video games.";
  };

  config = lib.mkIf config.alyraffauf.apps.steam.enable {
    hardware.steam-hardware.enable = true;
    programs.steam = {
      enable = true;
      remotePlay.openFirewall =
        true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall =
        true; # Open ports in the firewall for Source Dedicated Server
    };
  };
}
