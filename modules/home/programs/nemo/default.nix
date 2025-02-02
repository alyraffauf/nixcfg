{
  lib,
  pkgs,
  ...
}: {
  config = {
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
