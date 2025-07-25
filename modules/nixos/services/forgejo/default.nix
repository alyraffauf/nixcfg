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
    age.secrets = {
      forgejo-b2Id.file = "${self.inputs.secrets}/forgejo/b2Id.age";
      forgejo-b2Key.file = "${self.inputs.secrets}/forgejo/b2Key.age";
      forgejo-mailer-passwd.file = "${self.inputs.secrets}/forgejo/passwd.age";
    };

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

        lfs.enable = true;
        package = pkgs.forgejo;

        secrets = {
          mailer.PASSWD = config.age.secrets.forgejo-mailer-passwd.path;

          storage = {
            MINIO_ACCESS_KEY_ID = config.age.secrets.forgejo-b2Id.path;
            MINIO_SECRET_ACCESS_KEY = config.age.secrets.forgejo-b2Key.path;
          };
        };

        settings = {
          actions = {
            ARTIFACT_RETENTION_DAYS = 15;
            DEFAULT_ACTIONS_URL = "https://github.com";
            ENABLED = true;
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
            DOMAIN = config.mySnippets.cute-haus.networkMap.forgejo.vHost;
            HTTP_PORT = config.mySnippets.cute-haus.networkMap.forgejo.port;
            LANDING_PAGE = "explore";
            LFS_START_SERVER = true;
            ROOT_URL = "https://${config.mySnippets.cute-haus.networkMap.forgejo.vHost}/";
            SSH_DOMAIN = config.mySnippets.cute-haus.networkMap.forgejo.sshVHost;
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

          storage = {
            STORAGE_TYPE = "minio";
            MINIO_ENDPOINT = "s3.us-east-005.backblazeb2.com";
            MINIO_BUCKET_LOOKUP = "dns";
            MINIO_BUCKET = "aly-forgejo";
            MINIO_LOCATION = "us-east-005";
            MINIO_USE_SSL = true;
            MINIO_CHECKSUM_ALGORITHM = "md5";
          };

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
