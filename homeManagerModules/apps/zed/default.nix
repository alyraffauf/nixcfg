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
          adwaita-pastel = true;
          basher = true;
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
          ruby = true;
        };

        auto_update = false;
        autosave.after_delay.milliseconds = 1000;
        buffer_font_family = "NotoSansM Nerd Font";
        buffer_font_size = 14;
        current_line_highlight = "line";

        indent_guides = {
          enabled = true;
          background_coloring = "disabled";
          coloring = "indent_aware";
          line_width = 1;
        };

        languages = {
          Nix = {
            formatter.external = {
              command = lib.getExe pkgs.alejandra;
              arguments = [];
            };

            tab_size = 2;
          };
        };

        preferred_line_length = 80;

        tab_bar = {
          show = false;
          show_nav_history_buttons = false;
        };

        tabs = {
          close_position = "right";
          git_status = true;
        };

        telemetry = {
          diagnostics = true;
          metrics = true;
        };

        terminal.font_size = 12;

        theme = {
          dark = "Adwaita Pastel Dark";
          light = "Adwaita Pastel Light";
          mode = "system";
        };

        ui_font_size = 16;
        vim_mode = false;
      };
      settings = defaults // config.ar.home.apps.zed.settings;
    in
      lib.generators.toJSON {} settings;
  };
}