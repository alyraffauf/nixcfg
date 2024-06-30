{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.containers.nixos.navidrome.enable {
    age.secrets.lastFMApiKey.file = ../../../../secrets/lastFM/apiKey.age;
    age.secrets.lastFMSecret.file = ../../../../secrets/lastFM/secret.age;
    age.secrets.spotifyClientId.file = ../../../../secrets/spotify/clientId.age;
    age.secrets.spotifyClientSecret.file = ../../../../secrets/spotify/clientSecret.age;

    containers.navidrome = let
      navidromeConfig = builtins.toFile "navidrome.json" (lib.generators.toJSON {} {
        Address = "0.0.0.0";
        DefaultTheme = "Auto";
        MusicFolder = "/Music";
        Port = config.ar.containers.nixos.navidrome.port;
        SubsonicArtistParticipations = true;
        UIWelcomeMessage = "Welcome to Navidrome @ RaffaufLabs.com";
        "Spotify.ID" = "@spotifyClientId@";
        "Spotify.Secret" = "@spotifyClientSecret@";
        "LastFM.Enabled" = true;
        "LastFM.ApiKey" = "@lastFMApiKey@";
        "LastFM.Secret" = "@lastFMSecret@";
        "LastFM.Language" = "en";
      });
    in {
      autoStart = true;

      bindMounts = {
        "/Music".hostPath = config.ar.containers.nixos.navidrome.musicDirectory;
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
          system = {
            activationScripts."navidrome-secrets" = ''
              lastFMApiKey=$(cat "${lastFMApiKey}")
              lastFMSecret=$(cat "${lastFMSecret}")
              spotifyClientId=$(cat "${spotifyClientId}")
              spotifyClientSecret=$(cat "${spotifyClientSecret}")
              ${pkgs.gnused}/bin/sed -e "s/@lastFMApiKey@/$lastFMApiKey/" -e "s/@lastFMSecret@/$lastFMSecret/" \
                -e "s/@spotifyClientId@/$spotifyClientId/" -e "s/@spotifyClientSecret@/$spotifyClientSecret/" \
                /var/lib/navidrome/rawNavidrome.json > /var/lib/navidrome/navidrome.json
            '';

            stateVersion = "24.05";
          };

          systemd.services.navidrome.serviceConfig = {
            BindReadOnlyPaths = "/Music";

            ExecStart = lib.mkForce ''
              ${config.services.navidrome.package}/bin/navidrome --configfile /var/lib/navidrome/navidrome.json \
                --datafolder /var/lib/navidrome/
            '';
          };

          services.navidrome = {
            enable = true;
            openFirewall = true;
          };
        };
    };
  };
}
