{
  config,
  lib,
  pkgs,
  self,
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

  gtk.gtk3.bookmarks = lib.mkAfter [
    "file://${config.home.homeDirectory}/sync"
  ];

  home = {
    homeDirectory = "/home/aly";

    packages = with pkgs; [
      curl
      fractal
      nicotine-plus
      obsidian
      protonvpn-gui
      signal-desktop
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

  myHome = {
    defaultApps = {
      enable = true;
      terminal = config.programs.wezterm.package;
      webBrowser = config.programs.firefox.finalPackage;
    };

    profiles.shell.enable = true;

    programs = {
      chromium.enable = true;
      fastfetch.enable = true;
      firefox.enable = true;
      helix.enable = true;
      vsCodium.enable = true;
      wezterm.enable = true;
      yazi.enable = true;
    };
  };
}
