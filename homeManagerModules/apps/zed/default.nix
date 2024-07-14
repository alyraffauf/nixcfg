{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.ar.home.apps.zed;
in {
  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];

    cfg.settings = lib.mkDefault {
      "buffer_font_family" = "NotoSansM Nerd Font";
      "auto_update" = false;
      "vim_mode" = false;
      "theme" = "Adwaita Pastel Dark";
      "ui_font_size" = 16;
      "buffer_font_size" = 14;
      "autosave" = "on_focus_change";
      "indent_guides" = {
        "enabled" = true;
        "line_width" = 1;
        "coloring" = "indent_aware";
        "background_coloring" = "disabled";
      };
    };

    xdg.configFile."zed/settings.json".text =
      lib.generators.toJSON {}
      cfg.settings;
  };
}
