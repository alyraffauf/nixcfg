{ pkgs, lib, config, ... }: {

  options = {
    homeLab.nixContainers.enable = 
      lib.mkEnableOption "Enables select nix containers.";
  };

  config = lib.mkIf config.homeLab.nixContainers.enable {
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
  };
}