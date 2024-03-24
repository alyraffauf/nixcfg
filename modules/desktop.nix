{ config, pkgs, ... }:

{
  ## Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.variant = "";
    excludePackages = with pkgs; [
      xterm
    ];
  };

  ## Needed for Flatpaks
  xdg.portal.enable = true;

  services.flatpak.enable = true;

  environment.systemPackages = with pkgs; [
    firefox
    fractal
    gnome.gnome-software
    google-chrome
    tauon
    zoom-us
  ];

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Hack" "DroidSansMono" ]; })
    fira-code
    fira-code-symbols
    liberation_ttf
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
  ];

  fonts.fontDir.enable = true;
  
  system.fsPackages = [ pkgs.bindfs ];
  fileSystems = let
    mkRoSymBind = path: {
      device = path;
      fsType = "fuse.bindfs";
      options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
    };
    aggregatedFonts = pkgs.buildEnv {
      name = "system-fonts";
      paths = config.fonts.packages;
      pathsToLink = [ "/share/fonts" ];
    };
  in {
    # Create an FHS mount to support flatpak host icons/fonts
    "/usr/share/icons" = mkRoSymBind (config.system.path + "/share/icons");
    "/usr/share/fonts" = mkRoSymBind (aggregatedFonts + "/share/fonts");
  };
}
