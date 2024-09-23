self: {pkgs, ...}: {
  imports = [
    ./common.nix
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

  programs.rbw.settings.pinentry = pkgs.pinentry-gnome3;
  systemd.user.startServices = "legacy"; # Needed for auto-mounting agenix secrets.

  ar.home = {
    apps = {
      chromium.enable = true;
      firefox.enable = true;
      kitty.enable = true;
      vsCodium.enable = true;
    };

    defaultApps = {
      enable = true;
      fileManager = pkgs.xfce.thunar;
    };

    services.gammastep.enable = true;

    theme = {
      enable = true;
      borders.radius = 0;
    };
  };
}
