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
      "zed/themes/stylix.json".text = let
        theme = {
          "$schema" = "https://zed.dev/schema/themes/v0.1.0.json";
          author = "Aly Raffauf";
          name = "stylix";
          themes = [
            {
              appearance = config.stylix.polarity;
              name = "Stylix";
              style = {
                background = config.lib.stylix.colors.withHashtag.base00;
                border = config.lib.stylix.colors.withHashtag.base02;
                "border.disabled" = null;
                "border.focused" = null;
                "border.selected" = null;
                "border.transparent" = null;
                "border.variant" = config.lib.stylix.colors.withHashtag.base02;
                conflict = config.lib.stylix.colors.withHashtag.base0A;
                "conflict.background" = config.lib.stylix.colors.withHashtag.base00;
                "conflict.border" = config.lib.stylix.colors.withHashtag.base0A;
                created = config.lib.stylix.colors.withHashtag.base0B;
                "created.background" = config.lib.stylix.colors.withHashtag.base00;
                "created.border" = config.lib.stylix.colors.withHashtag.base0B;
                deleted = config.lib.stylix.colors.withHashtag.base08;
                "deleted.background" = config.lib.stylix.colors.withHashtag.base00;
                "deleted.border" = config.lib.stylix.colors.withHashtag.base08;
                "drop_target.background" = config.lib.stylix.colors.withHashtag.base02;
                "editor.active_line.background" = config.lib.stylix.colors.withHashtag.base01;
                "editor.active_line_number" = config.lib.stylix.colors.withHashtag.base05;
                "editor.active_wrap_guide" = config.lib.stylix.colors.withHashtag.base03;
                "editor.background" = config.lib.stylix.colors.withHashtag.base00;
                "editor.document_highlight.read_background" = config.lib.stylix.colors.withHashtag.base01;
                "editor.document_highlight.write_background" = config.lib.stylix.colors.withHashtag.base01;
                "editor.foreground" = config.lib.stylix.colors.withHashtag.base05;
                "editor.gutter.background" = config.lib.stylix.colors.withHashtag.base00;
                "editor.highlighted_line.background" = null;
                "editor.invisible" = null;
                "editor.line_number" = config.lib.stylix.colors.withHashtag.base03;
                "editor.subheader.background" = config.lib.stylix.colors.withHashtag.base00;
                "editor.wrap_guide" = config.lib.stylix.colors.withHashtag.base01;
                "element.active" = config.lib.stylix.colors.withHashtag.base03;
                "element.background" = config.lib.stylix.colors.withHashtag.base01;
                "element.disabled" = null;
                "element.hover" = config.lib.stylix.colors.withHashtag.base02;
                "element.selected" = config.lib.stylix.colors.withHashtag.base02;
                "elevated_surface.background" = config.lib.stylix.colors.withHashtag.base00;
                error = config.lib.stylix.colors.withHashtag.base08;
                "error.background" = config.lib.stylix.colors.withHashtag.base00;
                "error.border" = config.lib.stylix.colors.withHashtag.base08;
                "ghost_element.active" = null;
                "ghost_element.background" = null;
                "ghost_element.disabled" = null;
                "ghost_element.hover" = config.lib.stylix.colors.withHashtag.base01;
                "ghost_element.selected" = config.lib.stylix.colors.withHashtag.base02;
                hidden = config.lib.stylix.colors.withHashtag.base03;
                "hidden.background" = config.lib.stylix.colors.withHashtag.base00;
                "hidden.border" = config.lib.stylix.colors.withHashtag.base03;
                hint = config.lib.stylix.colors.withHashtag.base05;
                "hint.background" = config.lib.stylix.colors.withHashtag.base00;
                "hint.border" = config.lib.stylix.colors.withHashtag.base0C;
                icon = null;
                "icon.accent" = null;
                "icon.disabled" = null;
                "icon.muted" = null;
                "icon.placeholder" = null;
                ignored = config.lib.stylix.colors.withHashtag.base03;
                "ignored.background" = config.lib.stylix.colors.withHashtag.base00;
                "ignored.border" = config.lib.stylix.colors.withHashtag.base03;
                info = config.lib.stylix.colors.withHashtag.base0C;
                "info.background" = config.lib.stylix.colors.withHashtag.base00;
                "info.border" = config.lib.stylix.colors.withHashtag.base0C;
                "link_text.hover" = config.lib.stylix.colors.withHashtag.base0C;
                modified = config.lib.stylix.colors.withHashtag.base0D;
                "modified.background" = config.lib.stylix.colors.withHashtag.base00;
                "modified.border" = config.lib.stylix.colors.withHashtag.base0D;
                "pane.focused_border" = null;
                "panel.background" = config.lib.stylix.colors.withHashtag.base00;
                "panel.focused_border" = config.lib.stylix.colors.withHashtag.base02;
                players = [
                  {
                    background = null;
                    cursor = config.lib.stylix.colors.withHashtag.base05;
                    selection = config.lib.stylix.colors.withHashtag.base02;
                  }
                ];
                predictive = config.lib.stylix.colors.withHashtag.base03;
                "predictive.background" = config.lib.stylix.colors.withHashtag.base01;
                "predictive.border" = config.lib.stylix.colors.withHashtag.base02;
                renamed = config.lib.stylix.colors.withHashtag.base0A;
                "renamed.background" = config.lib.stylix.colors.withHashtag.base00;
                "renamed.border" = config.lib.stylix.colors.withHashtag.base0A;
                "scrollbar.thumb.border" = config.lib.stylix.colors.withHashtag.base02;
                "scrollbar.thumb.hover_background" = config.lib.stylix.colors.withHashtag.base03;
                "scrollbar.track.background" = config.lib.stylix.colors.withHashtag.base00;
                "scrollbar.track.border" = null;
                "scrollbar_thumb.background" = config.lib.stylix.colors.withHashtag.base02;
                "search.match_background" = config.lib.stylix.colors.withHashtag.base02;
                "status_bar.background" = config.lib.stylix.colors.withHashtag.base00;
                success = config.lib.stylix.colors.withHashtag.base0B;
                "success.background" = config.lib.stylix.colors.withHashtag.base00;
                "success.border" = config.lib.stylix.colors.withHashtag.base0B;
                "surface.background" = config.lib.stylix.colors.withHashtag.base00;
                syntax = {
                  attribute = {
                    color = config.lib.stylix.colors.withHashtag.base0D;
                    font_style = null;
                    font_weight = null;
                  };
                  boolean = {
                    color = config.lib.stylix.colors.withHashtag.base09;
                    font_style = null;
                    font_weight = null;
                  };
                  comment = {
                    color = config.lib.stylix.colors.withHashtag.base03;
                    font_style = "italic";
                    font_weight = null;
                  };
                  "comment.doc" = {
                    color = config.lib.stylix.colors.withHashtag.base03;
                    font_style = "italic";
                    font_weight = null;
                  };
                  constant = {
                    color = config.lib.stylix.colors.withHashtag.base09;
                    font_style = null;
                    font_weight = null;
                  };
                  constructor = {
                    color = config.lib.stylix.colors.withHashtag.base08;
                    font_style = null;
                    font_weight = null;
                  };
                  emphasis = {
                    color = config.lib.stylix.colors.withHashtag.base08;
                    font_style = "italic";
                    font_weight = null;
                  };
                  "emphasis.strong" = {
                    color = config.lib.stylix.colors.withHashtag.base08;
                    font_style = null;
                    font_weight = 700;
                  };
                  function = {
                    color = config.lib.stylix.colors.withHashtag.base0D;
                    font_style = null;
                    font_weight = null;
                  };
                  keyword = {
                    color = config.lib.stylix.colors.withHashtag.base09;
                    font_style = null;
                    font_weight = null;
                  };
                  label = {
                    color = config.lib.stylix.colors.withHashtag.base0A;
                    font_style = null;
                    font_weight = null;
                  };
                  link_text = {
                    color = config.lib.stylix.colors.withHashtag.base08;
                    font_style = null;
                    font_weight = null;
                  };
                  link_uri = {
                    color = config.lib.stylix.colors.withHashtag.base08;
                    font_style = null;
                    font_weight = null;
                  };
                  number = {
                    color = config.lib.stylix.colors.withHashtag.base09;
                    font_style = null;
                    font_weight = null;
                  };
                  punctuation = {
                    color = config.lib.stylix.colors.withHashtag.base05;
                    font_style = null;
                    font_weight = null;
                  };
                  "punctuation.bracket" = {
                    color = config.lib.stylix.colors.withHashtag.base05;
                    font_style = null;
                    font_weight = null;
                  };
                  "punctuation.delimiter" = {
                    color = config.lib.stylix.colors.withHashtag.base05;
                    font_style = null;
                    font_weight = null;
                  };
                  "punctuation.list_marker" = {
                    color = config.lib.stylix.colors.withHashtag.base05;
                    font_style = null;
                    font_weight = null;
                  };
                  "punctuation.special" = {
                    color = config.lib.stylix.colors.withHashtag.base05;
                    font_style = null;
                    font_weight = null;
                  };
                  string = {
                    color = config.lib.stylix.colors.withHashtag.base0B;
                    font_style = null;
                    font_weight = null;
                  };
                  "string.escape" = {
                    color = config.lib.stylix.colors.withHashtag.base09;
                    font_style = null;
                    font_weight = null;
                  };
                  "string.regex" = {
                    color = config.lib.stylix.colors.withHashtag.base0B;
                    font_style = null;
                    font_weight = null;
                  };
                  "string.special" = {
                    color = config.lib.stylix.colors.withHashtag.base0B;
                    font_style = null;
                    font_weight = null;
                  };
                  "string.special.symbol" = {
                    color = config.lib.stylix.colors.withHashtag.base0B;
                    font_style = null;
                    font_weight = null;
                  };
                  tag = {
                    color = config.lib.stylix.colors.withHashtag.base08;
                    font_style = null;
                    font_weight = null;
                  };
                  "text.literal" = {
                    color = config.lib.stylix.colors.withHashtag.base0B;
                    font_style = null;
                    font_weight = null;
                  };
                  title = {
                    color = config.lib.stylix.colors.withHashtag.base0A;
                    font_style = null;
                    font_weight = null;
                  };
                  type = {
                    color = config.lib.stylix.colors.withHashtag.base0A;
                    font_style = null;
                    font_weight = null;
                  };
                  variable = {
                    color = config.lib.stylix.colors.withHashtag.base06;
                    font_style = null;
                    font_weight = null;
                  };
                  "variable.special" = {
                    color = config.lib.stylix.colors.withHashtag.base08;
                    font_style = "italic";
                    font_weight = null;
                  };
                };
                "tab.active_background" = config.lib.stylix.colors.withHashtag.base00;
                "tab.inactive_background" = config.lib.stylix.colors.withHashtag.base01;
                "tab_bar.background" = config.lib.stylix.colors.withHashtag.base00;
                "terminal.ansi.black" = config.lib.stylix.colors.withHashtag.base00;
                "terminal.ansi.blue" = config.lib.stylix.colors.withHashtag.base0D;
                "terminal.ansi.bright_black" = config.lib.stylix.colors.withHashtag.base03;
                "terminal.ansi.bright_blue" = config.lib.stylix.colors.withHashtag.base0D;
                "terminal.ansi.bright_cyan" = config.lib.stylix.colors.withHashtag.base0C;
                "terminal.ansi.bright_green" = config.lib.stylix.colors.withHashtag.base0B;
                "terminal.ansi.bright_magenta" = config.lib.stylix.colors.withHashtag.base09;
                "terminal.ansi.bright_red" = config.lib.stylix.colors.withHashtag.base08;
                "terminal.ansi.bright_white" = config.lib.stylix.colors.withHashtag.base0F;
                "terminal.ansi.bright_yellow" = config.lib.stylix.colors.withHashtag.base0A;
                "terminal.ansi.cyan" = config.lib.stylix.colors.withHashtag.base0C;
                "terminal.ansi.dim_black" = null;
                "terminal.ansi.dim_blue" = null;
                "terminal.ansi.dim_cyan" = null;
                "terminal.ansi.dim_green" = null;
                "terminal.ansi.dim_magenta" = null;
                "terminal.ansi.dim_red" = null;
                "terminal.ansi.dim_white" = null;
                "terminal.ansi.dim_yellow" = null;
                "terminal.ansi.green" = config.lib.stylix.colors.withHashtag.base0B;
                "terminal.ansi.magenta" = config.lib.stylix.colors.withHashtag.base09;
                "terminal.ansi.red" = config.lib.stylix.colors.withHashtag.base08;
                "terminal.ansi.white" = config.lib.stylix.colors.withHashtag.base05;
                "terminal.ansi.yellow" = config.lib.stylix.colors.withHashtag.base0A;
                "terminal.background" = config.lib.stylix.colors.withHashtag.base00;
                "terminal.bright_foreground" = null;
                "terminal.dim_foreground" = null;
                "terminal.foreground" = null;
                text = config.lib.stylix.colors.withHashtag.base05;
                "text.accent" = config.lib.stylix.colors.withHashtag.base0C;
                "text.disabled" = config.lib.stylix.colors.withHashtag.base02;
                "text.muted" = config.lib.stylix.colors.withHashtag.base04;
                "text.placeholder" = config.lib.stylix.colors.withHashtag.base0F;
                "title_bar.background" = config.lib.stylix.colors.withHashtag.base00;
                "title_bar.inactive_background" = config.lib.stylix.colors.withHashtag.base01;
                "toolbar.background" = config.lib.stylix.colors.withHashtag.base00;
                unreachable = config.lib.stylix.colors.withHashtag.base0A;
                "unreachable.background" = config.lib.stylix.colors.withHashtag.base00;
                "unreachable.border" = config.lib.stylix.colors.withHashtag.base0A;
                warning = config.lib.stylix.colors.withHashtag.base0A;
                "warning.background" = config.lib.stylix.colors.withHashtag.base00;
                "warning.border" = config.lib.stylix.colors.withHashtag.base0A;
              };
            }
          ];
        };
      in
        lib.generators.toJSON {} theme;

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
          buffer_font_family = config.stylix.fonts.monospace.name;
          buffer_font_size = config.stylix.fonts.sizes.applications + 2;
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

          terminal.font_size = config.stylix.fonts.sizes.terminal + 2;

          theme = {
            dark = "Stylix";
            light = "Stylix";
            mode = "system";
          };

          ui_font_family = config.stylix.fonts.sansSerif.name;
          ui_font_size = config.stylix.fonts.sizes.applications + 4;
          use_autoclose = false;
          vim_mode = false;
        };

        settings = defaults // cfg.apps.zed.settings;
      in
        lib.generators.toJSON {} settings;
    };
  };
}
