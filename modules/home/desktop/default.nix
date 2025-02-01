{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./gnome
    ./hyprland
    ./kde
  ];

  options.myHome.desktop = {
    autoSuspend = lib.mkOption {
      description = "Whether to autosuspend on idle.";
      default = config.myHome.desktop.hyprland.enable or false;
      type = lib.types.bool;
    };

    windowManagerBinds = lib.mkOption {
      description = "Default binds for window management.";

      default = {
        Down = "down";
        Left = "left";
        Right = "right";
        Up = "up";
        H = "left";
        J = "down";
        K = "up";
        L = "right";
      };

      type = lib.types.attrs;
    };
  };

  config =
    lib.mkIf (
      config.myHome.desktop.gnome.enable
      || config.myHome.desktop.hyprland.enable
      || config.myHome.desktop.kde.enable
    ) {
      home.packages = [
        pkgs.adwaita-icon-theme
        pkgs.liberation_ttf
      ];

      dconf = {
        enable = true;

        settings = {
          "org/gnome/desktop/wm/preferences".button-layout =
            if config.myHome.desktop.kde.enable
            then "appmenu:minimize,maximize,close"
            else if config.myHome.desktop.gnome.enable
            then "appmenu:close"
            else "";

          "org/gnome/nm-applet".disable-connected-notifications = true;
          "org/gtk/gtk4/settings/file-chooser".sort-directories-first = true;
          "org/gtk/settings/file-chooser".sort-directories-first = true;
        };
      };

      gtk.gtk3.bookmarks = [
        "file://${config.xdg.userDirs.documents}"
        "file://${config.xdg.userDirs.download}"
        "file://${config.xdg.userDirs.music}"
        "file://${config.xdg.userDirs.videos}"
        "file://${config.xdg.userDirs.pictures}"
        "file://${config.home.homeDirectory}/src"
      ];

      xdg = {
        dataFile."backgrounds".source = self.inputs.wallpapers;

        userDirs = {
          enable = true;
          createDirectories = true;
          desktop = lib.mkDefault "${config.home.homeDirectory}/dsktp";
          documents = lib.mkDefault "${config.home.homeDirectory}/docs";
          download = lib.mkDefault "${config.home.homeDirectory}/dwnlds";
          extraConfig = {XDG_SRC_DIR = "${config.home.homeDirectory}/src";};
          music = lib.mkDefault "${config.home.homeDirectory}/music";
          pictures = lib.mkDefault "${config.home.homeDirectory}/pics";
          publicShare = lib.mkDefault "${config.home.homeDirectory}/pub";
          templates = lib.mkDefault "${config.home.homeDirectory}/tmplts";
          videos = lib.mkDefault "${config.home.homeDirectory}/vids";
        };
      };
    };
}
