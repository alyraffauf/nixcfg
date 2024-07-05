inputs: {
  config,
  pkgs,
  lib,
  ...
}: let
  mediaDirectory = "/mnt/Media";
  archiveDirectory = "/mnt/Archive";
in {
  imports = [
    ./containers
    ./options.nix
    ./services
  ];

  config = lib.mkIf config.raffauflabs.enable {
    raffauflabs.services.ddclient.enable = lib.mkDefault true;

    networking.firewall.allowedTCPPorts = [80 443];

    security.acme = {
      acceptTerms = true;
      defaults.email = config.raffauflabs.email;
    };

    services = {
      ddclient = let
        cfg = config.raffauflabs.services.ddclient;
      in {
        enable = cfg.enable;
        domains = [config.raffauflabs.domain];
        interval = "10min";
        passwordFile = cfg.passwordFile;
        protocol = cfg.protocol;
        ssl = true;
        use = "web, web=dynamicdns.park-your-domain.com/getip, web-skip='Current IP Address: '";
        username = "token";
        zone = config.raffauflabs.domain;
      };

      fail2ban.enable = true;

      nginx = {
        enable = true;
        recommendedGzipSettings = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
      };
    };
  };
}
