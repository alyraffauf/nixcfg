{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.programs.nemo.enable = lib.mkOption {
    description = "Cinnamon Nemo file manager.";
    default = config.myHome.defaultApps.fileManager == pkgs.nemo;
    type = lib.types.bool;
  };

  config = lib.mkIf config.myHome.programs.nemo.enable {
    home.packages = [pkgs.nemo];

    dconf = {
      enable = true;

      settings = {
        "org/nemo/preferences" = {
          show-image-thumbnails = "always";
          thumbnail-limit = lib.hm.gvariant.mkUint64 (100 * 1024 * 1024);
          tooltips-in-icon-view = true;
          tooltips-show-access-date = true;
          tooltips-show-birth-date = true;
          tooltips-show-file-type = true;
          tooltips-show-mod-date = true;
        };

        "org/nemo/preferences/menu-config" = {
          background-menu-open-as-root =
            !(config.myHome.desktop.hyprland.enable);
          selection-menu-open-as-root =
            !(config.myHome.desktop.hyprland.enable);
        };

        "org/nemo/plugins".disabled-actions =
          lib.optionals
          (config.myHome.desktop.hyprland.enable) [
            "90_new-launcher.nemo_action"
            "add-desklets.nemo_action"
            "change-background.nemo_action"
            "mount-archive.nemo_action"
            "set-as-background.nemo_action"
            "set-resolution.nemo_action"
          ];
      };
    };
  };
}
