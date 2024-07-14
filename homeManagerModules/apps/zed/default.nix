{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.home.apps.zed.enable {
    home.packages = [
      config.ar.home.apps.zed.package
      pkgs.nixd
    ];

    xdg.configFile."zed/settings.json".text = let
      defaults = {
        auto_install_extensions = {
          adwaita_pastel = true;
          bahser = true;
          docker-compose = true;
          dockerfile = true;
          git-firefly = true;
          haskell = true;
          html = true;
          ini = true;
          just = true;
          log = true;
          make = true;
          nix = true;
          python = true;
          ruby = true;
        };

        auto_update = false;
        autosave = "on_focus_change";
        buffer_font_family = "NotoSansM Nerd Font";
        buffer_font_size = 14;

        indent_guides = {
          enabled = true;
          background_coloring = "disabled";
          coloring = "indent_aware";
          line_width = 1;
        };

        languages = {
          Nix.formatter.external = {
            command = lib.getExe pkgs.alejandra;
            arguments = [];
          };
        };

        telemetry = {
          diagnostics = true;
          metrics = true;
        };

        theme =
          if config.ar.home.theme.darkMode
          then "Adwaita Pastel Dark"
          else "Adwaita Pastel Light";

        ui_font_size = 16;
        vim_mode = false;
      };
      settings = defaults // config.ar.home.apps.zed.settings;
    in
      lib.generators.toJSON {} settings;
  };
}
