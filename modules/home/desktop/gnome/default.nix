{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.desktop.gnome.enable = lib.mkEnableOption "GNOME desktop environment";

  config = lib.mkIf config.myHome.desktop.gnome.enable {
    dconf = {
      enable = true;

      settings = {
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
        };

        "org/gnome/mutter" = {
          dynamic-workspaces = true;
          edge-tiling = true;

          experimental-features = [
            "scale-monitor-framebuffer"
            "variable-refresh-rate"
          ];

          workspaces-only-on-primary = true;
        };

        "org/gnome/settings-daemon/plugins/media-keys" = {
          play = ["<Super>AudioMute"];
          previous = ["<Super>AudioLowerVolume"];
          next = ["<Super>AudioRaiseVolume"];
        };

        "org/gnome/shell" = {
          welcome-dialog-last-shown-version = "9999999999"; # No welcome dialog.
        };

        "org/gnome/shell/extensions/dash-to-dock" = {
          background-color = lib.mkIf config.stylix.targets.gnome.enable config.lib.stylix.colors.withHashtag.base01;
          click-action = "minimize";
          custom-background-color = true;
          custom-theme-shrink = false;
          dock-fixed = false;
          dock-postion = "LEFT";
          extend-height = false;
        };

        "org/gnome/system/location".enabled = true;
      };
    };

    programs = {
      firefox.nativeMessagingHosts = [pkgs.gnome-browser-connector];

      gnome-shell = {
        enable = true;

        extensions = [
          {package = pkgs.gnomeExtensions.appindicator;}
          {package = pkgs.gnomeExtensions.auto-move-windows;}
          {package = pkgs.gnomeExtensions.caffeine;}
          {package = pkgs.gnomeExtensions.dash-to-dock;}
          {package = pkgs.gnomeExtensions.dynamic-panel;}
          {package = pkgs.gnomeExtensions.night-theme-switcher;}
          {package = pkgs.gnomeExtensions.tiling-shell;}
          {package = pkgs.gnomeExtensions.vscode-search-provider;}
        ];
      };
    };

    myHome.profiles.defaultApps = {
      audioPlayer.package = lib.mkDefault pkgs.rhythmbox;
      editor.package = lib.mkDefault pkgs.gnome-text-editor;
      fileManager.package = lib.mkDefault pkgs.nautilus;
      imageViewer.package = lib.mkDefault pkgs.loupe;
      pdfViewer.package = lib.mkDefault pkgs.evince;
      terminal.package = lib.mkDefault pkgs.ptyxis;
      videoPlayer.package = lib.mkDefault pkgs.celluloid;
    };
  };
}
