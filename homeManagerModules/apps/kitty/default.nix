{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.ar.home;
in {
  config = lib.mkIf cfg.apps.kitty.enable {
    programs.kitty = {
      enable = true;

      font = {
        name = cfg.theme.monospaceFont.name;
        size = cfg.theme.monospaceFont.size + 1;
      };

      settings = {
        background_opacity = "0.6";
        confirm_os_window_close = "0";
        notify_on_cmd_finish = "unfocused 10.0 command ${lib.getExe pkgs.libnotify} -i ${pkgs.kitty}/share/icons/hicolor/256x256/apps/kitty.png \"Job Finished\"";
        tab_bar_style = "powerline";
      };

      extraConfig = ''
        # vim:ft=kitty

        ## name: Adwaita dark
        ## license: MIT
        ## author: Emil Löfquist (https://github.com/ewal)
        ## upstream: https://github.com/ewal/kitty-adwaita/blob/main/adwaita_dark.conf
        ## blurb: Adwaita dark - based on https://github.com/Mofiqul/adwaita.nvim

        background                ${cfg.theme.colors.background}
        foreground                ${cfg.theme.colors.text}

        selection_background      ${cfg.theme.colors.primary}
        selection_foreground      ${cfg.theme.colors.text}

        url_color                 ${cfg.theme.colors.primary}

        wayland_titlebar_color    system
        macos_titlebar_color      system

        cursor                    ${cfg.theme.colors.text}
        cursor_text_color         ${cfg.theme.colors.background}

        active_border_color       ${cfg.theme.colors.primary}
        inactive_border_color     ${cfg.theme.colors.inactive}
        bell_border_color         ${cfg.theme.colors.secondary}
        visual_bell_color         none

        active_tab_background     ${cfg.theme.colors.background}
        active_tab_foreground     ${cfg.theme.colors.text}
        inactive_tab_background   ${cfg.theme.colors.background}
        inactive_tab_foreground   ${cfg.theme.colors.inactive}
        tab_bar_background        none
        tab_bar_margin_color      none

        color0                    ${cfg.theme.colors.background}
        color1                    #ed333b
        color2                    #57e389
        color3                    #ff7800
        color4                    #62a0ea
        color5                    #9141ac
        color6                    #5bc8af
        color7                    ${cfg.theme.colors.text}

        color8                    #9a9996
        color9                    #f66151
        color10                   #8ff0a4
        color11                   #ffa348
        color12                   #99c1f1
        color13                   #dc8add
        color14                   #93ddc2
        color15                   #f6f5f4
      '';

      # theme = "Adwaita dark";
    };
  };
}
