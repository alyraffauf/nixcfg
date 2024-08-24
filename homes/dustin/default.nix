self: {
  config,
  lib,
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
      teams-for-linux
      trayscale
      webcord
      xfce.xfce4-taskmanager
      zoom-us
    ];
  };

  programs = {
    home-manager.enable = true;

    rbw = {
      enable = true;

      settings = {
        email = "dustinmraffauf@gmail.com";
        lock_timeout = 14400;
        pinentry = pkgs.pinentry-gnome3;
      };
    };
  };

  wayland.windowManager = {
    hyprland.settings = {
      bind = ["SUPER,P,exec,${lib.getExe pkgs.rofi-rbw-wayland}"];
    };

    sway.config = {
      input."type:keyboard" = lib.mkForce {
        xkb_layout = "us";
        xkb_variant = "altgr-intl";
      };

      keybindings = {
        "${config.wayland.windowManager.sway.config.modifier}+P" = "exec ${lib.getExe pkgs.rofi-rbw-wayland}";
      };

      output = {
        "Guangxi Century Innovation Display Electronics Co., Ltd 27C1U-D 0000000000001" = {
          scale = "1.5";
          pos = "-2560 0";
        };
      };
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications."application/epub+zip" = "com.calibre_ebook.calibre.desktop;org.gnome.Evince.desktop;com.calibre_ebook.calibre.ebook-viewer.desktop;";
  };

  ar.home = {
    apps = {
      chromium.enable = true;
      firefox.enable = true;
      kitty.enable = true;
      shell.enable = true;
      vsCodium.enable = true;
    };

    defaultApps.enable = true;

    desktop = {
      hyprland.monitors = [
        "desc:Guangxi Century Innovation Display Electronics Co. Ltd 27C1U-D 0000000000001,preferred,-2400x0,1.6"
        "desc:HP Inc. HP 24mh 3CM037248S,preferred,-1920x0,auto"
        "desc:LG Electronics LG IPS QHD 109NTWG4Y865,preferred,-2560x0,auto"
      ];
    };

    services = {
      gammastep.enable = true;
      randomWallpaper.enable = false;
    };

    theme.enable = true;
  };
}
