self: {
  config,
  pkgs,
  ...
}: {
  imports = [self.homeManagerModules.default];

  home = {
    username = "dustin";
    homeDirectory = "/home/dustin";
    stateVersion = "24.05";

    packages = with pkgs; [
      fractal
      libreoffice-fresh
      plexamp
      webcord
      xfce.xfce4-taskmanager
      zoom-us
    ];
  };

  programs.home-manager.enable = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplications."application/epub+zip" = "com.calibre_ebook.calibre.desktop;org.gnome.Evince.desktop;com.calibre_ebook.calibre.ebook-viewer.desktop;";
  };

  ar.home = {
    apps = {
      bash.enable = true;
      chromium.enable = true;
      firefox.enable = true;
      kitty.enable = true;
      vsCodium.enable = true;
    };

    defaultApps.enable = true;

    desktop.hyprland = {
      monitors = [
        "desc:Guangxi Century Innovation Display Electronics Co. Ltd 27C1U-D 0000000000001,preferred,-2400x0,1.6"
        "desc:HP Inc. HP 24mh 3CM037248S,preferred,-1920x0,auto"
        "desc:LG Electronics LG IPS QHD 109NTWG4Y865,preferred,-2560x0,auto"
      ];

      randomWallpaper = false;
    };

    theme = {
      enable = true;
      wallpaper = "${config.xdg.dataHome}/backgrounds/wallhaven-6d66dl.jpg";
    };
  };
}
