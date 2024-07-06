{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.raffauflabs.services.forgejo;
in {
  config = lib.mkIf cfg.enable {
    networking.extraHosts = ''
      127.0.0.1 ${cfg.subDomain}.${config.raffauflabs.domain}
    '';

    services = {
      ddclient.domains = ["${cfg.subDomain}.${config.raffauflabs.domain}"];

      forgejo = {
        enable = true;
        lfs.enable = true;

        settings = {
          actions = {
            ENABLED = true;
            DEFAULT_ACTIONS_URL = "https://github.com";
          };

          cron = {
            ENABLED = true;
            RUN_AT_START = false;
          };

          DEFAULT.APP_NAME = "Forĝejo";

          repository = {
            DEFAULT_BRANCH = "master";
            ENABLE_PUSH_CREATE_ORG = true;
            ENABLE_PUSH_CREATE_USER = true;
            PREFERRED_LICENSES = "GPL-3.0";
          };

          federation.ENABLED = true;
          picture.ENABLE_FEDERATED_AVATAR = true;
          security.PASSWORD_CHECK_PWN = true;

          server = {
            LANDING_PAGE = "explore";
            ROOT_URL = "https://${cfg.subDomain}.${config.raffauflabs.domain}/";
          };

          service = {
            ALLOW_ONLY_INTERNAL_REGISTRATION = true;
            DISABLE_REGISTRATION = false;
            ENABLE_NOTIFY_MAIL = true;
          };

          session.COOKIE_SECURE = true;

          ui.DEFAULT_THEME = "forgejo-auto";
          "ui.meta" = {
            AUTHOR = "Forĝejo @ ${config.raffauflabs.domain}";
            DESCRIPTION = "Self-hosted git forge for projects + toys.";
            KEYWORDS = "git,source code,forge,forĝejo,aly raffauf";
          };
        };
      };

      nginx.virtualHosts."git.${config.raffauflabs.domain}" = {
        enableACME = true;
        forceSSL = true;

        locations."/" = {
          proxyPass = "http://${config.services.forgejo.settings.server.HTTP_ADDR}:${toString config.services.forgejo.settings.server.HTTP_PORT}";

          extraConfig = ''
            client_max_body_size 512M;
          '';
        };
      };
    };
  };
}
