{
  config,
  inputs,
  lib,
  pkgs,
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
    # Spotify secrets aren't exactly safe, because they are world-readable in the nix store.
    # But they're reasonably disposable and hidden from the public git repo.
    age.secrets.spotifyClientId.file = ../../../../secrets/spotify/clientId.age;
    age.secrets.spotifyClientSecret.file = ../../../../secrets/spotify/clientSecret.age;

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
              DefaultTheme = "Auto";
              MusicFolder = "/Music";
              Port = port;
              SubsonicArtistParticipations = true;
              UIWelcomeMessage = "Welcome to Navidrome! Registrations are closed.";
            };
          };
        };
    };
  };
}
