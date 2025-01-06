self: {
  config,
  pkgs,
  ...
}: {
  imports = [
    ./firefox
    ./mail
    ./secrets.nix
    ./windowManagers
    self.homeManagerModules.default
    self.inputs.agenix.homeManagerModules.default
  ];

  home = {
    homeDirectory = "/home/aly";

    packages = with pkgs; [
      curl
      fractal
      nicotine-plus
      obsidian
      protonvpn-gui
      tauon
      transmission-remote-gtk
      vesktop
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
        github.user = "alyraffauf";
        push.autoSetupRemote = true;
      };
    };

    gitui.enable = true;
    home-manager.enable = true;

    rbw = {
      enable = true;

      settings = {
        base_url = "https://passwords.raffauflabs.com";
        email = "alyraffauf@fastmail.com";
        lock_timeout = 14400;
        pinentry = pkgs.pinentry-gnome3;
      };
    };
  };

  systemd.user.startServices = true; # Needed for auto-mounting agenix secrets.

  ar.home = {
    apps = {
      chromium.enable = true;
      fastfetch.enable = true;
      firefox.enable = true;
      ghostty.enable = true;
      helix.enable = true;
      kitty.enable = true;
      shell.enable = true;
      vsCodium.enable = true;
      yazi.enable = true;
    };

    defaultApps = {
      enable = true;
      terminal = pkgs.ghostty;
      webBrowser = config.ar.home.apps.chromium.package;
    };

    theme.enable = true;
  };
}
