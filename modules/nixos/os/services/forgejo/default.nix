{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  options.myNixOS.services.forgejo = {
    enable = lib.mkEnableOption "forgejo git forge";

    db = lib.mkOption {
      description = "Database to use (sqlite or postgresql).";
      default = "sqlite";
      type = lib.types.str;
    };
  };

  config = lib.mkIf config.myNixOS.services.forgejo.enable {
    age.secrets.forgejo-mailer-passwd.file = "${self.inputs.secrets}/forgejo/passwd.age";

    services = {
      postgresql = lib.mkIf (config.myNixOS.services.forgejo.db
        == "postgresql") {
        enable = true;
        package = pkgs.postgresql_16;
        ensureDatabases = ["forgejo"];

        ensureUsers = [
          {
            name = "forgejo";
            ensureDBOwnership = true;
          }
        ];
      };

      forgejo = {
        enable = true;

        database = lib.mkIf (config.myNixOS.services.forgejo.db
          == "postgresql") {
          createDatabase = true;
          host = "127.0.0.1";
          name = "forgejo";
          passwordFile = config.age.secrets.postgres-forgejo.path;
          type = "postgres";
          user = "forgejo";
        };

        dump.enable = true;
        lfs.enable = true;
        package = pkgs.forgejo;
        secrets.mailer.PASSWD = config.age.secrets.forgejo-mailer-passwd.path;

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
          federation.ENABLED = true;
          indexer.REPO_INDEXER_ENABLED = true;

          log = {
            ENABLE_SSH_LOG = true;
            LEVEL = "Debug";
          };

          mailer = {
            ENABLED = true;
            FROM = "Forĝejo <git@aly.social>";
            PROTOCOL = "smtp+starttls";
            SMTP_ADDR = "smtp.resend.com";
            SMTP_PORT = 587;
            USER = "resend";
          };

          picture = {
            AVATAR_MAX_FILE_SIZE = 5242880;
            ENABLE_FEDERATED_AVATAR = true;
          };

          repository = {
            DEFAULT_BRANCH = "master";
            ENABLE_PUSH_CREATE_ORG = true;
            ENABLE_PUSH_CREATE_USER = true;
            PREFERRED_LICENSES = "GPL-3.0";
          };

          security.PASSWORD_CHECK_PWN = true;

          server = {
            DOMAIN = "git.aly.codes";
            HTTP_PORT = 3001;
            LANDING_PAGE = "explore";
            LFS_START_SERVER = true;
            ROOT_URL = "https://git.aly.codes/";
            SSH_DOMAIN = "git.aly.codes";
            SSH_LISTEN_PORT = 2222;
            SSH_PORT = 2222;
            START_SSH_SERVER = true;
          };

          service = {
            ALLOW_ONLY_INTERNAL_REGISTRATION = true;
            DISABLE_REGISTRATION = true;
            ENABLE_NOTIFY_MAIL = true;
          };

          session.COOKIE_SECURE = true;
          ui.DEFAULT_THEME = "forgejo-auto";

          "ui.meta" = {
            AUTHOR = "Aly Raffauf";
            DESCRIPTION = "Self-hosted git forge for projects + toys.";
            KEYWORDS = "git,source code,forge,forĝejo,aly raffauf";
          };
        };
      };
    };
  };
}
