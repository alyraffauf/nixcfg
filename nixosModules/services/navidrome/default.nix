{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.services.navidrome.enable {
    age.secrets = let
      owner = "navidrome";
    in {
      lastFMApiKey = {
        inherit owner;
        file = ../../../secrets/lastFM/apiKey.age;
      };

      lastFMSecret = {
        inherit owner;
        file = ../../../secrets/lastFM/secret.age;
      };

      spotifyClientId = {
        inherit owner;
        file = ../../../secrets/spotify/clientId.age;
      };

      spotifyClientSecret = {
        inherit owner;
        file = ../../../secrets/spotify/clientSecret.age;
      };
    };

    services.navidrome.enable = true;

    systemd.services.navidrome.serviceConfig = let
      navidromeConfig = builtins.toFile "navidrome.json" (lib.generators.toJSON {} {
        Address = "0.0.0.0";
        DefaultTheme = "Auto";
        MusicFolder = config.ar.services.navidrome.musicDirectory;
        Port = config.ar.services.navidrome.port;
        SubsonicArtistParticipations = true;
        UIWelcomeMessage = "Welcome to Navidrome @ RaffaufLabs.com";
        "Spotify.ID" = "@spotifyClientId@";
        "Spotify.Secret" = "@spotifyClientSecret@";
        "LastFM.Enabled" = true;
        "LastFM.ApiKey" = "@lastFMApiKey@";
        "LastFM.Secret" = "@lastFMSecret@";
        "LastFM.Language" = "en";
      });

      navidrome-secrets = pkgs.writeShellScript "navidrome-secrets" ''
        lastFMApiKey=$(cat "${config.age.secrets.lastFMApiKey.path}")
        lastFMSecret=$(cat "${config.age.secrets.lastFMSecret.path}")
        spotifyClientId=$(cat "${config.age.secrets.spotifyClientId.path}")
        spotifyClientSecret=$(cat "${config.age.secrets.spotifyClientSecret.path}")
        ${pkgs.gnused}/bin/sed -e "s/@lastFMApiKey@/$lastFMApiKey/" -e "s/@lastFMSecret@/$lastFMSecret/" \
          -e "s/@spotifyClientId@/$spotifyClientId/" -e "s/@spotifyClientSecret@/$spotifyClientSecret/" \
          ${navidromeConfig} > /var/lib/navidrome/navidrome.json
      '';
    in {
      BindReadOnlyPaths = [
        config.age.secrets.lastFMApiKey.path
        config.age.secrets.lastFMSecret.path
        config.age.secrets.spotifyClientId.path
        config.age.secrets.spotifyClientSecret.path
        config.ar.services.navidrome.musicDirectory
      ];

      ExecStartPre = navidrome-secrets;
      ExecStart = lib.mkForce ''
        ${config.services.navidrome.package}/bin/navidrome --configfile /var/lib/navidrome/navidrome.json \
          --datafolder /var/lib/navidrome/
      '';
    };
  };
}
