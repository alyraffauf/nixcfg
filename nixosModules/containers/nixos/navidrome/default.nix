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
    age.secrets.lastFMApiKey.file = ../../../../secrets/lastFM/apiKey.age;
    age.secrets.lastFMSecret.file = ../../../../secrets/lastFM/secret.age;
    age.secrets.spotifyClientId.file = ../../../../secrets/spotify/clientId.age;
    age.secrets.spotifyClientSecret.file = ../../../../secrets/spotify/clientSecret.age;

    containers.navidrome = let
      navidromeConfig = builtins.toFile "navidrome.json" ''
        {
          "Address": "0.0.0.0",
          "DefaultTheme": "Auto",
          "MusicFolder": "/Music",
          "Port": ${toString config.alyraffauf.containers.nixos.navidrome.port},
          "SubsonicArtistParticipations": true,
          "UIWelcomeMessage": "Welcome to Navidrome! Registrations are closed.",
          "Spotify.ID": "@spotifyClientId@",
          "Spotify.Secret": "@spotifyClientSecret@",
          "LastFM.Enabled": true,
          "LastFM.ApiKey": "@lastFMApiKey@",
          "LastFM.Secret": "@lastFMSecret@",
          "LastFM.Language": "en"
        }
      '';
    in {
      autoStart = true;
      bindMounts = {
        "/Music".hostPath = config.alyraffauf.containers.nixos.navidrome.musicDirectory;
        "/var/lib/navidrome/rawNavidrome.json".hostPath = navidromeConfig;
        "${config.age.secrets.lastFMApiKey.path}".isReadOnly = true;
        "${config.age.secrets.lastFMSecret.path}".isReadOnly = true;
        "${config.age.secrets.spotifyClientId.path}".isReadOnly = true;
        "${config.age.secrets.spotifyClientSecret.path}".isReadOnly = true;
      };
      config = let
        lastFMApiKey = config.age.secrets.lastFMApiKey.path;
        lastFMSecret = config.age.secrets.lastFMSecret.path;
        spotifyClientId = config.age.secrets.spotifyClientId.path;
        spotifyClientSecret = config.age.secrets.spotifyClientSecret.path;
      in
        {
          config,
          pkgs,
          lib,
          ...
        }: {
          system.stateVersion = "24.05";
          system.activationScripts."navidrome-secrets" = ''
            lastFMApiKey=$(cat "${lastFMApiKey}")
            lastFMSecret=$(cat "${lastFMSecret}")
            spotifyClientId=$(cat "${spotifyClientId}")
            spotifyClientSecret=$(cat "${spotifyClientSecret}")
            ${pkgs.gnused}/bin/sed -e "s/@lastFMApiKey@/$lastFMApiKey/" -e "s/@lastFMSecret@/$lastFMSecret/" \
              -e "s/@spotifyClientId@/$spotifyClientId/" -e "s/@spotifyClientSecret@/$spotifyClientSecret/" \
              /var/lib/navidrome/rawNavidrome.json > /var/lib/navidrome/navidrome.json
          '';

          systemd.services.navidrome.serviceConfig = {
            ExecStart = lib.mkForce ''
              ${config.services.navidrome.package}/bin/navidrome --configfile /var/lib/navidrome/navidrome.json \
                --datafolder /var/lib/navidrome/
            '';
            BindReadOnlyPaths = "/Music";
          };
          services.navidrome = {
            enable = true;
            openFirewall = true;
          };
        };
    };
  };
}
