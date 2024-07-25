{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.ar.home;
in {
  config = lib.mkIf cfg.apps.rofi.enable {
    programs.rofi = {
      enable = true;
      font = "NotoSansM Nerd Font ${toString config.gtk.font.size}";
      location = "center";
      package = pkgs.rofi-wayland;
      plugins = [pkgs.rofi-power-menu];
      terminal = lib.getExe cfg.defaultApps.terminal;
      theme = "glue_pro_blue";

      extraConfig = {
        click-to-exit = true;
        combi-display-format = "{text}";
        combi-hide-mode-prefix = true;

        combi-modes = [
          "window"
          "drun"
          "ssh"
        ];

        display-drun = "  ";
        display-filebrowser = "  ";
        display-power-menu = "  ";
        display-run = "  ";
        display-ssh = "  ";
        display-window = " 﩯 ";
        drun-display-format = "{icon} {name}";
        hide-scrollbar = true;
        hover-select = true;
        me-accept-entry = "MousePrimary";
        me-select-entry = "";
        modes = "drun,window,ssh,combi,filebrowser";
        show-display-name = false;
        show-icons = true;
        sort = true;
        window-format = " {c} {t}";
        window-thumbnail = false;
      };
    };

    xdg.configFile."networkmanager-dmenu/config.ini".text = ''
      [dmenu]
      dmenu_command = ${lib.getExe config.programs.rofi.package}
      l = 40
      rofi_highlight = True

      [dmenu_passphrase]
      rofi_obscure = True

      [editor]
      gui_if_available = True
    '';
  };
}
