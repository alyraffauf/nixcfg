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

  wayland.windowManager.hyprland.extraConfig = ''
    exec-once = sleep 1 && ${lib.getExe' pkgs.keepassxc "keepassxc"}
    bind = SUPER, P, exec, ${lib.getExe' pkgs.keepassxc "keepassxc"}
    windowrulev2 = center(1),class:(org.keepassxc.KeePassXC)
    windowrulev2 = float,class:(org.keepassxc.KeePassXC)
    windowrulev2 = size 80% 80%,class:(org.keepassxc.KeePassXC)
  '';

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
      wallpaper = "${pkgs.alyraffauf-wallpapers}/share/backgrounds/wallhaven-3led2d.jpg";
    };
  };
}
