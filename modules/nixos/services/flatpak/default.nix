{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myNixOS.services.flatpak.enable = lib.mkEnableOption "flatpak package manager";
  config = lib.mkIf config.myNixOS.services.flatpak.enable {
    environment.systemPackages = lib.optionals config.services.xserver.enable [pkgs.gnome-software];

    fileSystems = let
      mkRoSymBind = path: {
        device = path;
        fsType = "fuse.bindfs";
        options = ["ro" "resolve-symlinks" "x-gvfs-hide"];
      };

      aggregatedIcons = pkgs.buildEnv {
        name = "system-icons";
        paths = with pkgs; [
          adwaita-icon-theme
          gnome-themes-extra
        ];

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
      packages = with pkgs; [
        adwaita-fonts
        nerd-fonts.caskaydia-cove
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
        source-code-pro
        source-sans-pro
      ];
    };

    services.flatpak.enable = true;
    system.fsPackages = [pkgs.bindfs];
    xdg.portal.enable = true;
  };
}
