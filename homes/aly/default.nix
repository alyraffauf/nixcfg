self: {
  config,
  lib,
  pkgs,
  ...
}: let
  unstable = import self.inputs.nixpkgs-unstable {
    system = pkgs.system;
  };
in {
  imports = [
    ./firefox
    ./mail
    ./windowManagers
    self.homeManagerModules.default
    self.inputs.agenix.homeManagerModules.default
    self.inputs.nixvim.homeManagerModules.nixvim
    self.inputs.nur.hmModules.nur
  ];

  home = {
    homeDirectory = "/home/aly";

    file."${config.xdg.cacheHome}/keepassxc/keepassxc.ini".text = lib.generators.toINI {} {
      General.LastActiveDatabase = "${config.home.homeDirectory}/sync/Passwords.kdbx";
    };

    packages = [
      pkgs.browsh
      pkgs.curl
      pkgs.fractal
      pkgs.git
      pkgs.nicotine-plus
      pkgs.obsidian
      pkgs.picard
      pkgs.tauon
      pkgs.webcord
    ];

    stateVersion = "24.05";
    username = "aly";
  };

  programs = {
    git = {
      enable = true;
      lfs.enable = true;
      userName = "Aly Raffauf";
      userEmail = "aly@raffauflabs.com";

      extraConfig = {
        color.ui = true;
        core.editor = "${lib.getExe unstable.zed-editor} --wait";
        github.user = "alyraffauf";
        push.autoSetupRemote = true;
      };
    };

    gitui.enable = true;
    home-manager.enable = true;

    nixvim = {
      enable = true;
      colorschemes.ayu.enable = true;

      plugins = {
        lightline.enable = true;
        markdown-preview.enable = true;
        neo-tree.enable = true;
        neogit.enable = true;
        nix.enable = true;
      };
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
      tmux.enable = true;
      vsCodium.enable = true;

      zed = {
        enable = true;
        package = unstable.zed-editor;
      };
    };

    defaultApps = {
      enable = true;
      editor = config.ar.home.apps.zed.package;
    };

    theme = {
      enable = true;
      wallpaper = "${config.xdg.dataHome}/backgrounds/wallhaven-3led2d.jpg";
    };
  };
}
