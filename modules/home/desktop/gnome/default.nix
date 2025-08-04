{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.desktop.gnome = {
    enable = lib.mkEnableOption "GNOME desktop environment";
    dock = lib.mkEnableOption "GNOME dash-to-dock extension";
  };

  config = lib.mkIf config.myHome.desktop.gnome.enable {
    dconf = {
      enable = true;

      settings = let
        defaultApps = {
          terminal = config.myHome.profiles.defaultApps.terminal.exec or (lib.getExe pkgs.ptyxis);
          webBrowser = config.myHome.profiles.defaultApps.webBrowser.exec or (lib.getExe config.programs.firefox.finalPackage);
          fileManager = config.myHome.profiles.defaultApps.fileManager.exec or (lib.getExe pkgs.nautilus);
          editor = config.myHome.profiles.defaultApps.editor.exec or (lib.getExe pkgs.gnome-text-editor);
        };
      in {
        "org/gnome/desktop/datetime".automatic-timezone = true;
        "org/gnome/desktop/input-sources".xkb-options = ["ctrl:nocaps"];

        "org/gnome/desktop/interface" = {
          clock-format = "12h";
          enable-hot-corners = true;
        };

        "org/gnome/desktop/peripherals/touchpad".tap-to-click = true;
        "org/gnome/desktop/search-providers".enabled = "['org.gnome.Calendar.desktop', 'org.gnome.Weather.desktop', 'org.gnome.Contacts.desktop', 'org.gnome.Calculator.desktop', 'org.gnome.Characters.desktop', 'org.gnome.clocks.desktop']";

        "org/gnome/desktop/wm/preferences" = {
          auto-raise = true;
          button-layout = "appmenu:minimize,maximize,close";
          num-workspaces = 10;
          resize-with-right-button = true;
        };

        "org/gnome/mutter" = {
          dynamic-workspaces = false;
          edge-tiling = false;

          experimental-features = [
            "scale-monitor-framebuffer"
            "variable-refresh-rate"
            "xwayland-native-scaling"
          ];

          workspaces-only-on-primary = true;
        };

        "org/gnome/settings-daemon/plugins/media-keys" = {
          custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
          ];

          play = ["<Super>AudioMute"];
          previous = ["<Super>AudioLowerVolume"];
          next = ["<Super>AudioRaiseVolume"];
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          binding = "<Super>t";
          command = "${defaultApps.terminal}";
          name = "Terminal";
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
          binding = "<Super>f";
          command = "${defaultApps.fileManager}";
          name = "File Manager";
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
          binding = "<Super>b";
          command = "${defaultApps.webBrowser}";
          name = "Web Browser";
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
          binding = "<Super>e";
          command = "${defaultApps.editor}";
          name = "Text Editor";
        };

        "org/gnome/shell" = {
          welcome-dialog-last-shown-version = "9999999999"; # No welcome dialog.
        };

        "org/gnome/shell/extensions/dash-to-dock" = lib.mkIf config.myHome.desktop.gnome.dock {
          click-action = "minimize";
          custom-theme-shrink = false;
          dock-fixed = false;
          dock-postion = "LEFT";
          extend-height = false;
          hot-keys = false;
        };

        "org/gnome/shell/extensions/tilingshell" = {
          tiling-system-activation-key = ["2"];
        };

        "org/gnome/shell/keybindings" = {
          switch-to-application-1 = [];
          switch-to-application-2 = [];
          switch-to-application-3 = [];
          switch-to-application-4 = [];
          switch-to-application-5 = [];
          switch-to-application-6 = [];
          switch-to-application-7 = [];
          switch-to-application-8 = [];
          switch-to-application-9 = [];
          switch-to-application-10 = [];
        };

        "org/gnome/system/location".enabled = true;

        "org/gnome/desktop/wm/keybindings" = {
          close = ["<Super>c"];
          minimize = []; # <Super>H
          move-to-monitor-down = ["<Ctrl><Shift><Super>j" "<Ctrl><Shift><Super>Up"];
          move-to-monitor-left = ["<Ctrl><Shift><Super>h" "<Ctrl><Shift><Super>Left"];
          move-to-monitor-right = ["<Ctrl><Shift><Super>l" "<Ctrl><Shift><Super>Right"];
          move-to-monitor-up = ["<Ctrl><Shift><Super>k" "<Ctrl><Shift><Super>Up"];
          move-to-workspace-1 = ["<Shift><Super>1"];
          move-to-workspace-10 = ["<Shift><Super>0"];
          move-to-workspace-2 = ["<Shift><Super>2"];
          move-to-workspace-3 = ["<Shift><Super>3"];
          move-to-workspace-4 = ["<Shift><Super>4"];
          move-to-workspace-5 = ["<Shift><Super>5"];
          move-to-workspace-6 = ["<Shift><Super>6"];
          move-to-workspace-7 = ["<Shift><Super>7"];
          move-to-workspace-8 = ["<Shift><Super>8"];
          move-to-workspace-9 = ["<Shift><Super>9"];
          move-to-workspace-down = ["<Shift><Super>j"];
          move-to-workspace-left = ["<Shift><Super>h" "<Shift><Super>Comma"];
          move-to-workspace-right = ["<Shift><Super>l" "<Shift><Super>Period"];
          move-to-workspace-up = ["<Shift><Super>k"];
          switch-to-workspace-1 = ["<Super>1"];
          switch-to-workspace-10 = ["<Super>0"];
          switch-to-workspace-2 = ["<Super>2"];
          switch-to-workspace-3 = ["<Super>3"];
          switch-to-workspace-4 = ["<Super>4"];
          switch-to-workspace-5 = ["<Super>5"];
          switch-to-workspace-6 = ["<Super>6"];
          switch-to-workspace-7 = ["<Super>7"];
          switch-to-workspace-8 = ["<Super>8"];
          switch-to-workspace-9 = ["<Super>9"];
          switch-to-workspace-down = [];
          switch-to-workspace-left = ["<Super>Comma"];
          switch-to-workspace-right = ["<Super>Period"];
          switch-to-workspace-up = [];
          toggle-fullscreen = ["<Super>w"];
        };
      };
    };

    programs = {
      firefox.nativeMessagingHosts = [pkgs.gnome-browser-connector];

      gnome-shell = {
        enable = true;

        extensions = [
          (lib.mkIf config.myHome.desktop.gnome.dock {package = pkgs.gnomeExtensions.dash-to-dock;})
          {package = pkgs.gnomeExtensions.appindicator;}
          {package = pkgs.gnomeExtensions.auto-move-windows;}
          {package = pkgs.gnomeExtensions.caffeine;}
          {package = pkgs.gnomeExtensions.night-theme-switcher;}
          {package = pkgs.gnomeExtensions.tiling-shell;}
        ];
      };
    };

    myHome.profiles.defaultApps = {
      audioPlayer.package = lib.mkDefault pkgs.rhythmbox;
      editor.package = lib.mkDefault pkgs.gnome-text-editor;
      fileManager.package = lib.mkDefault pkgs.nautilus;
      imageViewer.package = lib.mkDefault pkgs.loupe;
      pdfViewer.package = lib.mkDefault pkgs.papers;
      terminal.package = lib.mkDefault pkgs.ptyxis;
      videoPlayer.package = lib.mkDefault pkgs.celluloid;
    };
  };
}
