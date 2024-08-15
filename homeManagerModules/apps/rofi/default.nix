{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.ar.home;
in {
  config = lib.mkIf cfg.apps.rofi.enable {
    home.packages = [
      pkgs.networkmanager_dmenu
      pkgs.rofi-bluetooth
      pkgs.rofi-rbw-wayland
    ];

    programs.rofi = {
      enable = true;
      location = "center";
      package = pkgs.rofi-wayland;

      plugins = [
        pkgs.rofi-power-menu
        pkgs.rofi-file-browser
      ];

      terminal = lib.getExe cfg.defaultApps.terminal;

      extraConfig = {
        case-sensitive = false;
        click-to-exit = true;
        combi-display-format = "{text}";
        combi-hide-mode-prefix = true;

        combi-modes = [
          "window"
          "drun"
          "ssh"
          "recursivebrowser"
        ];

        display-combi = "Search";
        display-drun = "Apps";
        display-filebrowser = "Files";
        display-recursivebrowser = "Files";
        display-run = "Run";
        display-ssh = "SSH";
        display-window = "Windows";
        drun-display-format = "{icon} {name}";
        hover-select = true;
        matching = "fuzzy";
        me-accept-entry = "MousePrimary";
        me-select-entry = "";
        modes = "drun,window,ssh,recursivebrowser";
        scrollbar = false;
        show-display-name = false;
        show-icons = true;
        sort = true;
        window-format = " {c} {t}";
        window-thumbnail = false;
      };
    };

    xdg.configFile = {
      "rofi-rbw.rc".text = ''
        prompt "Bitwarden"
        clear-after 60
      '';

      "networkmanager-dmenu/config.ini".text = ''
        [dmenu]
        dmenu_command = ${lib.getExe config.programs.rofi.package}
        highlight = True

        [dmenu_passphrase]
        obscure = True

        [editor]
        gui = ${pkgs.networkmanagerapplet}/bin/nm-connection-editor
        gui_if_available = True
        terminal = ${lib.getExe cfg.defaultApps.terminal}
      '';
    };
  };
}
