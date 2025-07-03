{config, ...}: {
  services = {
    caddy.virtualHosts = {
      "homebridge.narwhal-snapper.ts.net" = {
        extraConfig = ''
          bind tailscale/homebridge
          encode zstd gzip
          reverse_proxy localhost:${toString config.myNixOS.services.homebridge.port}
        '';
      };
    };

    # ddclient = {
    #   enable = true;

    #   domains = [
    #     "audiobookshelf.cute.haus"
    #     "cute.haus"
    #     "forgejo.cute.haus"
    #     "immich.cute.haus"
    #     "karakeep.cute.haus"
    #     "navidrome.cute.haus"
    #     "ombi.cute.haus"
    #     "plex.cute.haus"
    #   ];

    #   interval = "10min";
    #   passwordFile = config.age.secrets.cloudflare.path;
    #   protocol = "cloudflare";
    #   ssl = true;
    #   username = "token";
    #   zone = "cute.haus";
    # };
  };
}
