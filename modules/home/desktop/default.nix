{
  config,
  lib,
  pkgs,
  ...
}: {
  config = {
    home.packages = [
      pkgs.adwaita-icon-theme
      pkgs.liberation_ttf
    ];

    dconf = {
      enable = true;

      settings = {
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

    xdg.userDirs = {
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
}
