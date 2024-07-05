{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.services.navidrome.enable {
    age.secrets.lastFMApiKey.file = ../../../secrets/lastFM/apiKey.age;
    age.secrets.lastFMSecret.file = ../../../secrets/lastFM/secret.age;
    age.secrets.spotifyClientId.file = ../../../secrets/spotify/clientId.age;
    age.secrets.spotifyClientSecret.file = ../../../secrets/spotify/clientSecret.age;

    system.activationScripts."navidrome-secrets" = let
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
    in ''
      lastFMApiKey=$(cat "${config.age.secrets.lastFMApiKey.path}")
      lastFMSecret=$(cat "${config.age.secrets.lastFMSecret.path}")
      spotifyClientId=$(cat "${config.age.secrets.spotifyClientId.path}")
      spotifyClientSecret=$(cat "${config.age.secrets.spotifyClientSecret.path}")
      ${pkgs.gnused}/bin/sed -e "s/@lastFMApiKey@/$lastFMApiKey/" -e "s/@lastFMSecret@/$lastFMSecret/" \
        -e "s/@spotifyClientId@/$spotifyClientId/" -e "s/@spotifyClientSecret@/$spotifyClientSecret/" \
        ${navidromeConfig} > /var/lib/navidrome/navidrome.json
    '';

    systemd.services.navidrome.serviceConfig = {
      BindReadOnlyPaths = "${config.ar.services.navidrome.musicDirectory}";
      ExecStart = lib.mkForce ''
        ${config.services.navidrome.package}/bin/navidrome --configfile /var/lib/navidrome/navidrome.json \
          --datafolder /var/lib/navidrome/
      '';
    };

    services.navidrome = {
      enable = true;
    };
  };
}
