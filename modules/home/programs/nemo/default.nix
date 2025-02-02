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
      };
    };
  };
}
