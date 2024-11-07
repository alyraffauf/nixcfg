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
    self.inputs.nur.hmModules.nur
  ];

  home = {
    homeDirectory = "/home/aly";

    packages = with pkgs; [
      bitwarden-desktop
      curl
      fractal
      nicotine-plus
      obsidian
      picard
      tauon
      transmission-remote-gtk
      tuba
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
      helix.enable = true;
      kitty.enable = true;
      shell.enable = true;
      vsCodium.enable = true;
      yazi.enable = true;
    };

    defaultApps = {
      enable = true;
      webBrowser = config.ar.home.apps.chromium.package;
    };

    theme.enable = true;
  };
}
