{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./chromium
    ./common.nix
    ./windowManagers
  ];

  gtk.gtk3.bookmarks = lib.mkAfter [
    "file://${config.home.homeDirectory}/sync"
  ];

  home = {
    homeDirectory = "/home/aly";

    packages = with pkgs; [
      fractal
      google-chrome
      nicotine-plus
      obsidian
      plexamp
      protonvpn-gui
      signal-desktop-bin
    ];

    stateVersion = "25.05";
    username = "aly";
  };

  programs.rbw = {
    enable = true;

    settings = {
      base_url = "https://vault.cute.haus";
      email = "alyraffauf@fastmail.com";
      lock_timeout = 14400;
      pinentry = pkgs.pinentry-gnome3;
    };
  };

  systemd.user.startServices = true; # Needed for auto-mounting agenix secrets.

  myHome.profiles.defaultApps = {
    enable = true;
    editor.package = config.programs.vscode.package;
    terminal.package = config.programs.ghostty.package;

    webBrowser = {
      exec = lib.getExe config.programs.zen-browser.finalPackage;
      package = config.programs.zen-browser.finalPackage;
    };
  };
}
