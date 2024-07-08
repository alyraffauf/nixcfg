inputs: self: {
  config,
  lib,
  pkgs,
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

  systemd.user.startServices = "legacy"; # Needed for auto-mounting agenix secrets.

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

    theme = {
      enable = true;
      wallpaper = "${inputs.wallpapers.packages.${pkgs.system}.default}/share/backgrounds/wallhaven-3led2d.jpg";
    };
  };
}
