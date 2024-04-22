{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.services.flatpak.enable =
      lib.mkEnableOption "Enables flatpak support with GUI.";
  };

  config = lib.mkIf config.alyraffauf.services.flatpak.enable {
    # Needed for Flatpaks
    xdg.portal.enable = true;
    services.flatpak.enable = true;
    fonts.fontDir.enable = true;

    # Allow access to system fonts.
    system.fsPackages = [pkgs.bindfs];
    fileSystems = let
      mkRoSymBind = path: {
        device = path;
        fsType = "fuse.bindfs";
        options = ["ro" "resolve-symlinks" "x-gvfs-hide"];
      };
      aggregatedFonts = pkgs.buildEnv {
        name = "system-fonts";
        paths = config.fonts.packages;
        pathsToLink = ["/share/fonts"];
      };
    in {
      # Create an FHS mount to support flatpak host icons/fonts
      "/usr/share/icons" = mkRoSymBind (config.system.path + "/share/icons");
      "/usr/share/fonts" = mkRoSymBind (aggregatedFonts + "/share/fonts");
    };
    environment.systemPackages = with pkgs; [gnome.gnome-software];
  };
}
