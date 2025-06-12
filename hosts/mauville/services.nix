{config, ...}: {
  networking = {
    firewall.allowedTCPPorts = [80 443 2379 2380 3000 6443 61208];
    firewall.allowedUDPPorts = [8472];
  };

  services = {
    audiobookshelf = {
      enable = true;
      host = "0.0.0.0";
      openFirewall = true;
      port = 13378;
    };

    karakeep = {
      enable = true;

      extraEnvironment = rec {
        DISABLE_NEW_RELEASE_CHECK = "true";
        DISABLE_SIGNUPS = "true";
        INFERENCE_CONTEXT_LENGTH = "128000";
        INFERENCE_EMBEDDING_MODEL = "nomic-embed-text";
        INFERENCE_ENABLE_AUTO_SUMMARIZATION = "true";
        INFERENCE_IMAGE_MODEL = "gemma3:4b";
        INFERENCE_JOB_TIMEOUT_SEC = "600";
        INFERENCE_LANG = "english";
        INFERENCE_TEXT_MODEL = INFERENCE_IMAGE_MODEL;
        NEXTAUTH_URL = "https://karakeep.cute.haus/";
        OLLAMA_BASE_URL = "https://ollama.${config.mySnippets.tailnet}";
        OLLAMA_KEEP_ALIVE = "5m";
        PORT = "7020";
      };
    };

    # navidrome = {
    #   enable = true;
    #   openFirewall = true;
    # };

    # slskd = {
    #   enable = true;
    #   domain = "0.0.0.0";
    #   environmentFile = config.age.secrets.slskd.path;
    #   openFirewall = true;

    #   settings = {
    #     directories.downloads = "/mnt/Media/Inbox/Music";
    #     shares.directories = ["/mnt/Media/Music"];
    #     soulseek.connection.buffer.read = 4096;
    #     soulseek.connection.buffer.write = 4096;
    #     soulseek.connection.buffer.transfer = 81920;
    #     soulseek.distributedNetwork.childLimit = 10;

    #     global = {
    #       download = {
    #         limit = 500; # Limit downloads to 500 KB/s
    #         slots = 4;
    #       };

    #       limits = {
    #         daily.megabytes = 1024; # Limit daily uplolads to 1GB
    #         weekly.megabytes = 10240; # Limit weekly uploads to 10GB
    #       };

    #       upload = {
    #         limit = 320; # Limit uploads to 32 KB/s
    #         slots = 4;
    #       };
    #     };
    #   };
    # };
  };

  # systemd.services = {
  #   navidrome.serviceConfig = let
  #     navidromeConfig = builtins.toFile "navidrome.json" (lib.generators.toJSON {} {
  #       Address = "0.0.0.0";
  #       DefaultTheme = "Auto";
  #       MusicFolder = musicDirectory;
  #       Port = navidrome.port;
  #       SubsonicArtistParticipations = true;
  #       UIWelcomeMessage = "Welcome to Navidrome @ ${domain}";
  #       "Spotify.ID" = "@spotifyClientId@";
  #       "Spotify.Secret" = "@spotifyClientSecret@";
  #       "LastFM.Enabled" = true;
  #       "LastFM.ApiKey" = "@lastFMApiKey@";
  #       "LastFM.Secret" = "@lastFMSecret@";
  #       "LastFM.Language" = "en";
  #     });

  #     navidrome-secrets = pkgs.writeShellScript "navidrome-secrets" ''
  #       lastFMApiKey=$(cat "${navidrome.lastfm.idFile}")
  #       lastFMSecret=$(cat "${navidrome.lastfm.secretFile}")
  #       spotifyClientId=$(cat "${navidrome.spotify.idFile}")
  #       spotifyClientSecret=$(cat "${navidrome.spotify.secretFile}")
  #       ${pkgs.gnused}/bin/sed -e "s/@lastFMApiKey@/$lastFMApiKey/" -e "s/@lastFMSecret@/$lastFMSecret/" \
  #         -e "s/@spotifyClientId@/$spotifyClientId/" -e "s/@spotifyClientSecret@/$spotifyClientSecret/" \
  #         ${navidromeConfig} > /var/lib/navidrome/navidrome.json
  #     '';
  #   in {
  #     BindReadOnlyPaths = [
  #       navidrome.lastfm.idFile
  #       navidrome.lastfm.secretFile
  #       navidrome.spotify.idFile
  #       navidrome.spotify.secretFile
  #       musicDirectory
  #     ];

  #     ExecStartPre = navidrome-secrets;
  #     ExecStart = lib.mkForce ''
  #       ${config.services.navidrome.package}/bin/navidrome --configfile /var/lib/navidrome/navidrome.json \
  #         --datafolder /var/lib/navidrome/
  #     '';
  #   };
  # };
}
