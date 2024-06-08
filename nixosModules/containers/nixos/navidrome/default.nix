{
  pkgs,
  lib,
  config,
  self,
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
    alyraffauf.containers.nixos.navidrome.port = lib.mkOption {
      description = "Port for Navidrome.";
      default = 4533;
      type = lib.types.int;
    };
  };

  config = lib.mkIf config.alyraffauf.containers.nixos.navidrome.enable {
    containers.navidrome = {
      autoStart = true;
      bindMounts."/Music".hostPath = config.alyraffauf.containers.nixos.navidrome.musicDirectory;
      config = let
        port = config.alyraffauf.containers.nixos.navidrome.port;
      in
        {
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
              Port = port;
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
