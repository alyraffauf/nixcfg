{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.containers.nixos.navidrome.enable =
      lib.mkEnableOption "Enable navidrome nixos container.";
    alyraffauf.containers.nixos.navidrome.musicDirectory = lib.mkOption {
      description = "Music directory for Navidrome.";
      default = "/mnt/Media/Music";
      type = lib.types.str;
    };
  };

  config = lib.mkIf config.alyraffauf.containers.nixos.navidrome.enable {
    containers.navidrome = {
      autoStart = true;
      bindMounts."/Music".hostPath = config.alyraffauf.containers.nixos.navidrome.musicDirectory;
      config = {
        config,
        pkgs,
        lib,
        ...
      }: {
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
            UIWelcomeMessage = "Welcome to Navidrome! Registrations are closed.";
          };
        };
      };
    };
  };
}
