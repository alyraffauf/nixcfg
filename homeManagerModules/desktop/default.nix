{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./cinnamon
    ./gnome
    ./hyprland
    ./sway
    ./startupApps.nix
    ./waylandComp.nix
  ];

  config = lib.mkIf config.alyraffauf.desktop.enable {
    dconf = {
      enable = true;
      settings = {
        "org/virt-manager/virt-manager/connections" = {
          autoconnect = ["qemu:///system"];
          uris = ["qemu:///system"];
        };
      };
    };

    gtk.gtk3.bookmarks = [
      "file://${config.xdg.userDirs.documents}"
      "file://${config.xdg.userDirs.download}"
      "file://${config.xdg.userDirs.music}"
      "file://${config.xdg.userDirs.videos}"
      "file://${config.xdg.userDirs.pictures}"
      "file://${config.home.homeDirectory}/src"
      "file://${config.home.homeDirectory}/sync"
    ];

    xdg = {
      dataFile."backgrounds/".source = ../../files/wallpapers;
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
