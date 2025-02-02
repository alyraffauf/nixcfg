{
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    self.homeManagerModules.profiles-defaultApps
    self.homeManagerModules.profiles-shell
    self.homeManagerModules.programs-chromium
    self.homeManagerModules.programs-firefox
    self.homeManagerModules.programs-vsCodium
    self.homeManagerModules.programs-wezterm
  ];

  home = {
    username = "dustin";
    homeDirectory = "/home/dustin";
    stateVersion = "24.05";

    packages = with pkgs; [
      fractal
      libreoffice-still
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
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications."application/epub+zip" = "com.calibre_ebook.calibre.desktop;org.gnome.Evince.desktop;com.calibre_ebook.calibre.ebook-viewer.desktop;";
  };
}
