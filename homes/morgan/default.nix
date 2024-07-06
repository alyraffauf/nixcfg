{
  config,
  inputs,
  lib,
  pkgs,
  self,
  ...
}: {
  home = {
    username = "morgan";
    homeDirectory = "/home/morgan";
    stateVersion = "24.05";
    packages = with pkgs; [
      fractal
      libreoffice-fresh
      webcord
      xfce.xfce4-taskmanager
    ];
  };

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "Morgan Tamayo";
      userEmail = "mrgntamayo@gmail.com";
    };
  };

  ar.home = {
    apps = {
      alacritty.enable = true;
      bash.enable = true;
      chromium.enable = true;
      firefox.enable = true;
      vsCodium.enable = true;
    };

    defaultApps.enable = true;

    theme = {
      enable = true;
      wallpaper = "${pkgs.alyraffauf-wallpapers}/share//backgrounds/jr-korpa-9XngoIpxcEo-unsplash.jpg";
    };
  };
}
