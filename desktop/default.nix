{ config, pkgs, ... }:

{
  ## Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.excludePackages = with pkgs; [
    xterm
  ];

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  ## Needed for Flatpaks
  xdg.portal.enable = true;

  services.flatpak.enable = true;
  services.flatpak.update.onActivation = true;
  services.flatpak.packages = [
    "md.obsidian.Obsidian"
  ];

  environment.systemPackages = with pkgs; [
    firefox
    google-chrome
    zoom-us
  ];

  # services.flatpak.overrides = {
  #   sockets = [
  #     "gpg-agent" # Expose GPG agent
  #     "pcsc" # Expose smart cards (i.e. YubiKey)
  #   ];
  #   "org.onlyoffice.desktopeditors".Context.sockets = ["x11"]; # No Wayland support
  # };

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
