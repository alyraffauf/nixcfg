{
  config,
  lib,
  ...
}: {
  options.myNixOS.services.fail2ban.enable = lib.mkEnableOption "fail2ban";

  config = lib.mkIf config.myNixOS.services.fail2ban.enable {
    environment.etc = {
      "fail2ban/filter.d/audiobookshelf.conf".text = ''
        [Definition]
        failregex = \[.*\] ERROR: \[Auth\] Failed login attempt for username \".*\" from ip <HOST> \(User not found\)
        ignoreregex =
        journalmatch = _SYSTEMD_UNIT=audiobookshelf.service
      '';

      "fail2ban/filter.d/forgejo.conf".text = ''
        [Definition]
        failregex =  .*(Failed authentication attempt|invalid credentials|Attempted access of unknown user).* from <HOST>
        journalmatch = _SYSTEMD_UNIT=forgejo.service
      '';

      "fail2ban/filter.d/karakeep.conf".text = ''
        [Definition]
        failregex = ^.*error:\s+Authentication\serror\..*IP-Address:\s+"?<HOST>"?.*$
        ignoreregex =
        journalmatch = _SYSTEMD_UNIT=karakeep-web.service
      '';

      "fail2ban/filter.d/navidrome.conf".text = ''
        [INCLUDES]
        before = common.conf

        [Definition]
        failregex = msg="Unsuccessful login".*X-Real-Ip:\[<HOST>\]
        ignoreregex =
        journalmatch = _SYSTEMD_UNIT=navidrome.service
      '';

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

    services.fail2ban = {
      enable = true;
      ignoreIP = ["100.64.0.0/10"];
      bantime = "24h";
      bantime-increment.enable = true;

      jails = {
        audiobookshelf = ''
          enabled = true
          backend = systemd
          filter = audiobookshelf
          maxretry = 5
          port = 80,443,${toString config.services.audiobookshelf.port}
        '';

        couchdb = ''
          enabled = true
          filter = couchdb
          port = 80,443,${toString config.services.couchdb.port}
          maxretry = 5
        '';

        forgejo.settings = {
          action = "iptables-allports";
          bantime = 900;
          filter = "forgejo";
          findtime = 3600;
          maxretry = 4;
        };

        karakeep = ''
          enabled = true
          backend = systemd
          filter = karakeep
          maxretry = 5
          port = 80,443,7020
        '';

        navidrome = ''
          enabled = true
          backend = systemd
          filter = navidrome
          maxretry = 5
          port = 0,443,${toString config.services.navidrome.settings.Port}
        '';

        # HTTP basic-auth failures, 5 tries → 1-day ban
        nginx-http-auth = {
          settings = {
            enabled = true;
            maxretry = 5;
            findtime = 300;
            bantime = "24h";
          };
        };

        # Generic scanner / bot patterns (wp-login.php, sqladmin, etc.)
        nginx-botsearch = {
          settings = {
            enabled = true;
            maxretry = 10;
            findtime = 300;
            bantime = "24h";
          };
        };

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
  };
}
