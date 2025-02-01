{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myHome;
in {
  options.myHome.apps.zed.enable = lib.mkEnableOption "Zed text editor.";

  config = lib.mkIf cfg.apps.zed.enable {
    home.packages = [
      pkgs.nixd
    ];

    programs.zed-editor = {
      enable = true;

      extensions = [
        "adwaita-pastel"
        "basher"
        "docker-compose"
        "dockerfile"
        "git-firefly"
        "haskell"
        "html"
        "ini"
        "just"
        "log"
        "make"
        "nix"
        "ruby"
      ];

      userKeymaps = [
        {
          "context" = "Workspace";
          "bindings" = {
            "alt-e" = "file_finder::Toggle";
            "ctrl-p" = "command_palette::Toggle";
            "ctrl-shift-p" = "file_finder::Toggle";
          };
        }
      ];

      userSettings = {
        auto_update = false;
        autosave.after_delay.milliseconds = 1000;
        # buffer_font_family = config.stylix.fonts.monospace.name;
        # buffer_font_size = config.stylix.fonts.sizes.applications + 2;
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
        restore_on_startup = "last_workspace";
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

        # terminal.font_size = config.stylix.fonts.sizes.terminal + 2;

        # ui_font_family = config.stylix.fonts.sansSerif.name;
        # ui_font_size = config.stylix.fonts.sizes.applications + 4;
        use_autoclose = false;
        vim_mode = false;
      };
    };
  };
}
