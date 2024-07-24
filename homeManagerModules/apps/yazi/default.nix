{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.ar.home.apps.yazi.enable {
    programs.yazi = {
      enable = true;
      enableBashIntegration = true;

      settings = {
        log.enabled = false;

        manager = {
          show_hidden = false;
          sort_by = "modified";
          sort_dir_first = true;
          sort_reverse = true;
          sort_sensitive = true;
          linemode = "size";
          show_symlink = true;
        };

        preview.tab_size = 4;
      };
    };
  };
}
