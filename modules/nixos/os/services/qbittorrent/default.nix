# Borrowed graciously from https://github.com/WiredMic/nix-config/commit/d9268ce5190a2041ef66b492900eed278d1508e2#diff-9db90aeeaf81739c27dcdab8065abc8709d0bd5428bc658cff2db46acc91536a
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myNixOS.services.qbittorrent;
  UID = 888;
  GID = 888;
in {
  options.myNixOS.services.qbittorrent = {
    enable = lib.mkEnableOption "qBittorrent headless";

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/qbittorrent";
      description = "The directory where qBittorrent stores its data files.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "qbittorrent";
      description = "User account under which qBittorrent runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "qbittorrent";
      description = "Group under which qBittorrent runs.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "qBittorrent web UI port.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open services.qBittorrent.port to the outside network.";
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.qbittorrent-nox;
      defaultText = lib.literalExpression "pkgs.qbittorrent-nox";
      description = "The qbittorrent package to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall =
      lib.mkIf cfg.openFirewall {allowedTCPPorts = [cfg.port];};

    systemd.services.qbittorrent = {
      after = ["local-fs.target" "network-online.target"];
      description = "qBittorrent-nox service";
      documentation = ["man:qbittorrent-nox(1)"];
      requires = ["local-fs.target" "network-online.target"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;

        # Run the pre-start script with full permissions (the "!" prefix) so it
        # can create the data directory if necessary.
        ExecStartPre = let
          preStartScript = pkgs.writeScript "qbittorrent-run-prestart" ''
            #!${pkgs.bash}/bin/bash

            # Create data directory if it doesn't exist
            if ! test -d "$QBT_PROFILE"; then
              echo "Creating initial qBittorrent data directory in: $QBT_PROFILE"
              install -d -m 0755 -o "${cfg.user}" -g "${cfg.group}" "$QBT_PROFILE"
            fi
          '';
        in "!${preStartScript}";

        ExecStart = "${cfg.package}/bin/qbittorrent-nox";
        # To prevent "Quit & shutdown daemon" from working; we want systemd to
        # manage it!
        #Restart = "on-success";
        #UMask = "0002";
        #LimitNOFILE = cfg.openFilesLimit;
      };

      environment = {
        QBT_PROFILE = cfg.dataDir;
        QBT_WEBUI_PORT = toString cfg.port;
      };
    };

    users.users = lib.mkIf (cfg.user == "qbittorrent") {
      qbittorrent = {
        group = cfg.group;
        uid = UID;
      };
    };

    users.groups =
      lib.mkIf (cfg.group == "qbittorrent") {qbittorrent = {gid = GID;};};
  };
}
