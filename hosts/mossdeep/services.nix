{
  config,
  pkgs,
  ...
}: {
  services = {
    pds = {
      enable = true;
      environmentFiles = [config.age.secrets.pds.path];
      pdsadmin.enable = true;
      settings.PDS_HOSTNAME = "aly.social";
    };

    postgresql = {
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
      dump.enable = true;
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

        database = {
          createDatabase = false;
          host = "127.0.0.1";
          name = "forgejo";
          passwordFile = config.age.secrets.postgres-forgejo.path;
          type = "postgres";
          user = "forgejo";
        };

        DEFAULT.APP_NAME = "Forĝejo";
        federation.ENABLED = true;
        indexer.REPO_INDEXER_ENABLED = true;

        log = {
          ENABLE_SSH_LOG = true;
          LEVEL = "Debug";
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
}
