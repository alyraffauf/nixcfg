{ config, pkgs, ... }:

{
  xdg.portal.enable = true;

  services.flatpak.enable = true;
  services.flatpak.packages = [
    "com.valvesoftware.Steam"
    "org.mozilla.firefox"
    "com.github.tchx84.Flatseal"
  ];
  services.flatpak.overrides = {
    global = {
      # Force Wayland by default
      # Context.sockets = ["wayland" "!x11" "!fallback-x11"];

      # Environment = {
      #   # Fix un-themed cursor in some Wayland apps
      #   XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";

      #   # # Force correct theme for some GTK apps
      #   # GTK_THEME = "Adwaita:dark";
      # };
    };

    "com.visualstudio.code".Context = {
      filesystems = [
        "xdg-config/git:ro" # Expose user Git config
        "/run/current-system/sw/bin:ro" # Expose NixOS managed software
      ];
      sockets = [
        "gpg-agent" # Expose GPG agent
        "pcsc" # Expose smart cards (i.e. YubiKey)
      ];
    };

    "org.onlyoffice.desktopeditors".Context.sockets = ["x11"]; # No Wayland support
  };
  system.fsPackages = [ pkgs.bindfs ];
  fileSystems = let
    mkRoSymBind = path: {
      device = path;
      fsType = "fuse.bindfs";
      options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
    };
    aggregatedFonts = pkgs.buildEnv {
      name = "system-fonts";
      paths = config.fonts.fonts;
      pathsToLink = [ "/share/fonts" ];
    };
  in {
    # Create an FHS mount to support flatpak host icons/fonts
    "/usr/share/icons" = mkRoSymBind (config.system.path + "/share/icons");
    "/usr/share/fonts" = mkRoSymBind (aggregatedFonts + "/share/fonts");
  };
}
