{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.services.flatpak.enable {
    environment.systemPackages = with pkgs; [gnome.gnome-software];

    fileSystems = let
      mkRoSymBind = path: {
        device = path;
        fsType = "fuse.bindfs";
        options = ["ro" "resolve-symlinks" "x-gvfs-hide"];
      };

      aggregatedIcons = pkgs.buildEnv {
        name = "system-icons";
        paths =
          (with pkgs; [
            gnome.adwaita-icon-theme
            gnome.gnome-themes-extra
          ])
          ++ lib.optional (config.stylix.enable) config.stylix.cursor.package;

        pathsToLink = ["/share/icons"];
      };

      aggregatedFonts = pkgs.buildEnv {
        name = "system-fonts";
        paths = config.fonts.packages;
        pathsToLink = ["/share/fonts"];
      };
    in {
      "/usr/share/icons" = mkRoSymBind "${aggregatedIcons}/share/icons";
      "/usr/local/share/fonts" = mkRoSymBind "${aggregatedFonts}/share/fonts";
    };

    fonts = {
      fontDir.enable = true;
      packages =
        (with pkgs; [
          noto-fonts
          noto-fonts-emoji
          noto-fonts-cjk
        ])
        ++ lib.optionals (config.stylix.enable) [
          config.stylix.fonts.sansSerif.package
          config.stylix.fonts.monospace.package
          config.stylix.fonts.serif.package
        ];
    };

    services.flatpak.enable = true;
    system.fsPackages = [pkgs.bindfs];
    xdg.portal.enable = true;
  };
}
