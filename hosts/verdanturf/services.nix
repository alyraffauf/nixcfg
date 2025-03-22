{
  config,
  pkgs,
  ...
}: {
  environment.etc = {
    "fail2ban/filter.d/vaultwarden.conf".text = ''
      [INCLUDES]
      before = common.conf

      [Definition]
      failregex = ^.*Username or password is incorrect\. Try again\. IP: <ADDR>\. Username:.*$
      ignoreregex =
      journalmatch = _SYSTEMD_UNIT=vaultwarden.service
    '';

    "fail2ban/filter.d/couchdb.conf".text = ''
      [INCLUDES]
      before = common.conf

      [Definition]
      failregex = \[warning\] \d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d+Z couchdb@\d+\.\d+\.\d+\.\d+ .* couch_httpd_auth: Authentication failed for user .* from <HOST>
      ignoreregex =
      journalmatch = _SYSTEMD_UNIT=couchdb.service
    '';

    "fail2ban/filter.d/vaultwarden-admin.conf".text = ''
      [INCLUDES]
      before = common.conf

      [Definition]
      failregex = ^.*Invalid admin token\. IP: <ADDR>.*$
      ignoreregex =
      journalmatch = _SYSTEMD_UNIT=vaultwarden.service
    '';
  };

  services = {
    couchdb = {
      enable = true;

      extraConfig = {
        couchdb = {
          single_node = true;
          max_document_size = 50000000;
        };

        chttpd = {
          require_valid_user = true;
          max_http_request_size = 4294967296;
          enable_cors = true;
        };

        chttpd_auth = {
          require_valid_user = true;
          authentication_redirect = "/_utils/session.html";
        };

        httpd = {
          enable_cors = true;
          "WWW-Authenticate" = "Basic realm=\"couchdb\"";
          bind_address = "0.0.0.0";
        };

        cors = {
          origins = "app://obsidian.md,capacitor://localhost,http://localhost";
          credentials = true;
          headers = "accept, authorization, content-type, origin, referer";
          methods = "GET,PUT,POST,HEAD,DELETE";
          max_age = 3600;
        };
      };
    };

    fail2ban = {
      enable = true;
      ignoreIP = ["100.64.0.0/10"];
      bantime = "24h";
      bantime-increment.enable = true;

      jails = {
        couchdb = ''
          enabled = true
          filter = couchdb
          port = 80,443,${toString config.services.couchdb.port}
          maxretry = 5
        '';

        vaultwarden = ''
          enabled = true
          filter = vaultwarden
          port = 80,443,${toString config.services.vaultwarden.config.ROCKET_PORT}
          maxretry = 5
        '';

        vaultwarden-admin = ''
          enabled = true
          port = 80,443,${toString config.services.vaultwarden.config.ROCKET_PORT}
          filter = vaultwarden-admin
          maxretry = 3
          bantime = 14400
          findtime = 14400
        '';
      };
    };

    pds = {
      enable = true;
      environmentFiles = [config.age.secrets.pds.path];
      pdsadmin.enable = true;
      settings.PDS_HOSTNAME = "aly.social";
    };

    restic.backups = let
      defaults = {
        inhibitsSleep = true;
        initialize = true;
        passwordFile = config.age.secrets.restic-passwd.path;

        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 5"
          "--keep-monthly 12"
          "--compression max"
        ];

        rcloneConfigFile = config.age.secrets.rclone-b2.path;

        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
          RandomizedDelaySec = "1h";
        };
      };
    in {
      couchdb =
        defaults
        // {
          backupCleanupCommand = ''
            ${pkgs.systemd}/bin/systemctl start couchdb
          '';

          backupPrepareCommand = ''
            ${pkgs.systemd}/bin/systemctl stop couchdb
          '';

          paths = ["/var/lib/couchdb"];
          repository = "rclone:b2:aly-backups/${config.networking.hostName}/couchdb";
        };

      pds =
        defaults
        // {
          backupCleanupCommand = ''
            ${pkgs.systemd}/bin/systemctl start pds
          '';

          backupPrepareCommand = ''
            ${pkgs.systemd}/bin/systemctl stop pds
          '';

          paths = ["/var/lib/pds"];
          repository = "rclone:b2:aly-backups/${config.networking.hostName}/pds";
        };

      vaultwarden =
        defaults
        // {
          backupCleanupCommand = ''
            ${pkgs.systemd}/bin/systemctl start vaultwarden
          '';

          backupPrepareCommand = ''
            ${pkgs.systemd}/bin/systemctl stop vaultwarden
          '';

          paths = ["/var/lib/vaultwarden"];
          repository = "rclone:b2:aly-backups/${config.networking.hostName}/vaultwarden";
        };
    };

    vaultwarden = {
      enable = true;

      config = {
        DOMAIN = "https://vault.cute.haus";
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_LOG = "critical";
        ROCKET_PORT = 8222;
        SIGNUPS_ALLOWED = false;
      };

      environmentFile = config.age.secrets.vaultwarden.path;
    };
  };
}
