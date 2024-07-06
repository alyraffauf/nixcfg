{
  config,
  inputs,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./firefox
    ./mail
    ./windowManagers
  ];

  home = {
    homeDirectory = "/home/aly";

    file."${config.xdg.cacheHome}/keepassxc/keepassxc.ini".text = lib.generators.toINI {} {
      General.LastActiveDatabase = "${config.home.homeDirectory}/sync/Passwords.kdbx";
    };

    packages = with pkgs; [
      inputs.wallpapers.packages.${pkgs.system}.default
      browsh
      curl
      fractal
      gh
      git
      obsidian
      python3
      ruby
      tauon
      webcord
      wget
    ];

    stateVersion = "24.05";
    username = "aly";
  };

  programs = {
    home-manager.enable = true;

    git = {
      enable = true;
      lfs.enable = true;
      userName = "Aly Raffauf";
      userEmail = "aly@raffauflabs.com";
    };
  };

  ar.home = {
    apps = {
      alacritty.enable = true;
      bash.enable = true;
      chromium.enable = true;
      emacs.enable = true;
      fastfetch.enable = true;
      firefox.enable = true;
      keepassxc.enable = true;
      neovim.enable = true;
      tmux.enable = true;
      vsCodium.enable = true;
    };

    defaultApps.enable = true;
    desktop.startupApps = [(lib.getExe' pkgs.keepassxc "keepassxc")];

    theme = {
      enable = true;
      wallpaper = "${config.xdg.dataHome}/backgrounds/wallhaven-3led2d.jpg";
    };
  };
}
