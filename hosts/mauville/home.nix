{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  home-manager = {
    sharedModules = [
      {
        programs.vscode.userSettings = {
          "editor.fontSize" = "16";
        };
        xdg.userDirs.music = "/mnt/Media/Music";
        alyraffauf.desktop.hyprland.autoSuspend = false;
        alyraffauf.desktop.sway.autoSuspend = false;
        alyraffauf.desktop.theme = lib.mkForce {
          enable = true;
          gtk = {
            name = "Catppuccin-Latte-Compact-Mauve-Light";
            package = pkgs.catppuccin-gtk.override {
              accents = ["mauve"];
              size = "compact";
              variant = "latte";
              tweaks = ["normal"];
            };
          };
          qt = {
            name = "Catppuccin-Latte-Mauve";
            package = pkgs.catppuccin-kvantum.override {
              accent = "Mauve";
              variant = "Latte";
            };
          };
          iconTheme = {
            name = "Papirus-Light";
            package = pkgs.catppuccin-papirus-folders.override {
              flavor = "latte";
              accent = "mauve";
            };
          };
          cursorTheme = {
            name = "Catppuccin-Latte-Dark-Cursors";
            size = 32;
            package = pkgs.catppuccin-cursors.latteDark;
          };
          font = {
            name = "NotoSans Nerd Font";
            size = 14;
            package = pkgs.nerdfonts.override {fonts = ["Noto"];};
          };
          terminalFont = {
            name = "NotoSansM Nerd Font";
            size = 14;
            package = pkgs.nerdfonts.override {fonts = ["Noto"];};
          };
          colors = {
            preferDark = false;
            text = "#4c4f69";
            background = "#eff1f5";
            primary = "#8839ef";
            secondary = "#04a5e5";
            inactive = "#626880";
            shadow = "#1A1A1A";
          };
        };
      }
    ];
    users.aly = {
      imports = [../../aly.nix];
      systemd.user = {
        services.backblaze-sync = {
          Unit = {
            Description = "Backup to Backblaze.";
          };
          Service = {
            ExecStart = "${pkgs.writeShellScript "backblaze-sync" ''
              BACKBLAZE=${lib.getExe pkgs.backblaze-b2}

              $BACKBLAZE sync --delete /mnt/Media/Music b2://aly-music
              $BACKBLAZE sync --delete /mnt/Media/Audiobooks b2://aly-audiobooks
              $BACKBLAZE sync --delete /mnt/Archive/Archive b2://aly-archive

              $BACKBLAZE sync --delete /home/aly/sync b2://aly-sync
              $BACKBLAZE sync --delete /home/aly/pics/camera b2://aly-camera
            ''}";
          };
        };
        timers.backblaze-sync = {
          Unit = {
            Description = "Daily backups to Backblaze.";
          };
          Install = {
            WantedBy = ["timers.target"];
          };
          Timer = {
            OnCalendar = "*-*-* 03:00:00";
          };
        };
      };
    };
    users.dustin = import ../../dustin.nix;
  };
}
