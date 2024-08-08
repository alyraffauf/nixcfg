{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.ar.home;
in {
  config = lib.mkIf cfg.apps.zed.enable {
    home.packages = [
      cfg.apps.zed.package
      pkgs.nixd
    ];

    xdg.configFile = {
      "zed/keymap.json".text = let
        defaults = [
          {
            "context" = "Workspace";
            "bindings" = {
              "alt-e" = "file_finder::Toggle";
              "ctrl-p" = "command_palette::Toggle";
              "ctrl-shift-p" = "file_finder::Toggle";
            };
          }
        ];
        keymaps = defaults ++ cfg.apps.zed.keymaps;
      in
        lib.generators.toJSON {} keymaps;

      "zed/settings.json".text = let
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
          buffer_font_family = cfg.theme.monospaceFont.name;
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
          show_wrap_guides = true;
          soft_wrap = "preferred_line_length";

          tab_bar = {
            show = true;
            show_nav_history_buttons = false;
          };

          tabs = {
            close_position = "right";
            git_status = true;
          };

          telemetry = {
            diagnostics = false;
            metrics = false;
          };

          terminal.font_size = 14;

          theme = {
            dark = "Adwaita Pastel Dark";
            light = "Adwaita Pastel Light";
            mode = "system";
          };

          ui_font_family = cfg.theme.sansFont.name;
          ui_font_size = 16;
          use_autoclose = false;
          vim_mode = false;
        };

        settings = defaults // cfg.apps.zed.settings;
      in
        lib.generators.toJSON {} settings;
    };
  };
}
