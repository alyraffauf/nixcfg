{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.raffauflabs.services.navidrome;
in {
  config = lib.mkIf cfg.enable {
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
        UIWelcomeMessage = "Welcome to Navidrome @ ${config.raffauflabs.domain}";
        "Spotify.ID" = "@spotifyClientId@";
        "Spotify.Secret" = "@spotifyClientSecret@";
        "LastFM.Enabled" = true;
        "LastFM.ApiKey" = "@lastFMApiKey@";
        "LastFM.Secret" = "@lastFMSecret@";
        "LastFM.Language" = "en";
      });

      navidrome-secrets = pkgs.writeShellScript "navidrome-secrets" ''
        lastFMApiKey=$(cat "${cfg.lastfm.idFile}")
        lastFMSecret=$(cat "${cfg.lastfm.secretFile}")
        spotifyClientId=$(cat "${cfg.spotify.idFile}")
        spotifyClientSecret=$(cat "${cfg.spotify.secretFile}")
        ${pkgs.gnused}/bin/sed -e "s/@lastFMApiKey@/$lastFMApiKey/" -e "s/@lastFMSecret@/$lastFMSecret/" \
          -e "s/@spotifyClientId@/$spotifyClientId/" -e "s/@spotifyClientSecret@/$spotifyClientSecret/" \
          ${navidromeConfig} > /var/lib/navidrome/navidrome.json
      '';
    in {
      BindReadOnlyPaths = [
        cfg.lastfm.idFile
        cfg.lastfm.secretFile
        cfg.spotify.idFile
        cfg.spotify.secretFile
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
