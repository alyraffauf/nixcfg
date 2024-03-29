{ config, pkgs, ... }:

{
  containers.navidrome = {
    autoStart = true;
    bindMounts."/Music".hostPath = "/mnt/Media/Music";
    config = { config, pkgs, lib, ... }: {
      system.stateVersion = "24.05";
      services.navidrome = {
        enable = true;
        openFirewall = true;
        settings = {
          Address = "0.0.0.0";
          Port = 4533;
          MusicFolder = "/Music";
          DefaultTheme = "Auto";
          SubsonicArtistParticipations = true;
          UIWelcomeMessage = "Welcome to Navidrome @ raffauflabs.com.";
        };
      };
    };
  };
}
