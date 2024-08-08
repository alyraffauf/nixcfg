{
  config,
  lib,
  osConfig,
  ...
}: {
  imports = [
    ./hyprland
    ./sway
    ./wayland
  ];

  config =
    lib.mkIf (
      config.ar.home.desktop.hyprland.enable
      || config.ar.home.desktop.sway.enable
    ) {
      dconf = {
        enable = true;
        settings = {
          "org/gtk/gtk4/settings/file-chooser".sort-directories-first = true;
          "org/gtk/settings/file-chooser".sort-directories-first = true;

          "org/virt-manager/virt-manager/connections" = {
            autoconnect = ["qemu:///system"];
            uris = ["qemu:///system"];
          };
        };
      };

      gtk.gtk3.bookmarks =
        [
          "file://${config.xdg.userDirs.documents}"
          "file://${config.xdg.userDirs.download}"
          "file://${config.xdg.userDirs.music}"
          "file://${config.xdg.userDirs.videos}"
          "file://${config.xdg.userDirs.pictures}"
          "file://${config.home.homeDirectory}/src"
        ]
        ++ lib.optional (
          osConfig.ar.users.aly.syncthing.enable
          && (config.home.username == "aly")
        ) "file://${config.home.homeDirectory}/sync";

      xdg = {
        dataFile."backgrounds".source = builtins.fetchGit {
          url = "https://github.com/alyraffauf/wallpapers.git";
          rev = "21018eef106928c7c44d206c6c3730cce5f781f3";
          ref = "master";
        };

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
