{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./common.nix
    self.homeManagerModules.default
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

  systemd.user.startServices = true; # Needed for auto-mounting agenix secrets.

  myHome = {
    aly = {
      desktop.hyprland.enable = config.wayland.windowManager.hyprland.enable;

      programs = {
        chromium.enable = true;
        rbw.enable = true;
      };
    };

    profiles.defaultApps = {
      enable = true;
      editor.package = config.programs.vscode.package;
      terminal.package = config.programs.ghostty.package;

      webBrowser = {
        exec = lib.getExe config.programs.zen-browser.finalPackage;
        package = config.programs.zen-browser.finalPackage;
      };
    };
  };
}
