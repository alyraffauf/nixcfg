{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.raffauflabs.services.navidrome;
in {
  config = lib.mkIf cfg.enable {
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

    networking.extraHosts = ''
      127.0.0.1 ${cfg.subDomain}.${config.raffauflabs.domain}
    '';

    services = {
      ddclient.domains = ["${cfg.subDomain}.${config.raffauflabs.domain}"];
      navidrome.enable = true;

      nginx.virtualHosts."${cfg.subDomain}.${config.raffauflabs.domain}" = {
        enableACME = true;
        forceSSL = true;

        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
          proxyWebsockets = true;

          extraConfig = ''
            proxy_buffering off;
          '';
        };
      };
    };

    systemd.services.navidrome.serviceConfig = let
      navidromeConfig = builtins.toFile "navidrome.json" (lib.generators.toJSON {} {
        Address = "0.0.0.0";
        DefaultTheme = "Auto";
        MusicFolder = cfg.musicDirectory;
        Port = cfg.port;
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
        cfg.musicDirectory
      ];

      ExecStartPre = navidrome-secrets;
      ExecStart = lib.mkForce ''
        ${config.services.navidrome.package}/bin/navidrome --configfile /var/lib/navidrome/navidrome.json \
          --datafolder /var/lib/navidrome/
      '';
    };
  };
}
