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
      font = "${cfg.theme.monospaceFont.name} ${toString cfg.theme.monospaceFont.size}";
      location = "center";
      package = pkgs.rofi-wayland;

      plugins = [
        pkgs.rofi-power-menu
        pkgs.rofi-file-browser
      ];

      terminal = lib.getExe cfg.defaultApps.terminal;
      theme = "theme.rasi";

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

      "rofi/theme.rasi".text = ''
        * {
            selected-normal-foreground:  ${cfg.theme.colors.secondary};
            foreground:                  ${cfg.theme.colors.text};
            normal-foreground:           @foreground;
            alternate-normal-background: transparent;
            red:                         ${cfg.theme.colors.secondary}CC;
            selected-urgent-foreground:  ${cfg.theme.colors.secondary}CC;
            blue:                        ${cfg.theme.colors.primary}CC;
            urgent-foreground:           ${cfg.theme.colors.primary}CC;
            alternate-urgent-background: transparent;
            active-foreground:           ${cfg.theme.colors.primary}CC;
            lightbg:                     rgba ( 238, 232, 213, 80 % );
            selected-active-foreground:  ${cfg.theme.colors.secondary};
            alternate-active-background: transparent;
            background:                  transparent;
            bordercolor:                 ${cfg.theme.colors.background}99;
            alternate-normal-foreground: @foreground;
            normal-background:           transparent;
            lightfg:                     ${cfg.theme.colors.primary}CC;
            selected-normal-background:  ${cfg.theme.colors.background};
            border-color:                ${cfg.theme.colors.primary}CC;
            spacing:                     2;
            separatorcolor:              ${cfg.theme.colors.primary}CC;
            urgent-background:           transparent;
            selected-urgent-background:  ${cfg.theme.colors.primary}CC;
            alternate-urgent-foreground: @urgent-foreground;
            background-color:            transparent;
            alternate-active-foreground: @active-foreground;
            active-background:           transparent;
            selected-active-background:  ${cfg.theme.colors.background};
        }
        window {
            background-color: ${cfg.theme.colors.background}CC;
            border:           4;
            border-color:     @border-color;
            border-radius:    10px;
            padding:          0;
        }
        mainbox {
            border:  0;
            padding: 0;
        }
        message {
            border:       2px solid 0px 0px ;
            border-color: @separatorcolor;
            padding:      1px ;
        }
        textbox {
            text-color: @foreground;
        }
        listview {
            fixed-height: 0;
            border:       2px solid 0px 0px ;
            border-color: @separatorcolor;
            spacing:      2px ;
            scrollbar:    false;
            padding:      5px;
        }
        element {
            border:  0;
            padding: 5px;
            border-radius:    10px;
        }
        element-text {
            background-color: inherit;
            text-color:       inherit;
        }
        element.normal.normal {
            background-color: @normal-background;
            text-color:       @normal-foreground;
        }
        element.normal.urgent {
            background-color: @urgent-background;
            text-color:       @urgent-foreground;
        }
        element.normal.active {
            background-color: @active-background;
            text-color:       @active-foreground;
        }
        element.selected.normal {
            background-color: @selected-normal-background;
            text-color:       @selected-normal-foreground;
        }
        element.selected.urgent {
            background-color: @selected-urgent-background;
            text-color:       @selected-urgent-foreground;
        }
        element.selected.active {
            background-color: @selected-active-background;
            text-color:       @selected-active-foreground;
        }
        element.alternate.normal {
            background-color: @alternate-normal-background;
            text-color:       @alternate-normal-foreground;
        }
        element.alternate.urgent {
            background-color: @alternate-urgent-background;
            text-color:       @alternate-urgent-foreground;
        }
        element.alternate.active {
            background-color: @alternate-active-background;
            text-color:       @alternate-active-foreground;
        }
        scrollbar {
            width:        0px ;
            border:       0;
            handle-width: 0px ;
            padding:      0;
        }
        mode-switcher {
            border:       2px solid 0px 0px ;
            border-color: @separatorcolor;
        }
        button.selected {
            background-color: @selected-normal-background;
            text-color:       @selected-normal-foreground;
        }
        button {
            background-color: @background;
            text-color:       @foreground;
        }
        inputbar {
            spacing:    0;
            text-color: @normal-foreground;
            padding:    10px ;
        }
        case-indicator {
            spacing:    0;
            text-color: @normal-foreground;
        }
        entry {
            spacing:    0;
            text-color: @normal-foreground;
        }
        prompt {
            spacing:    0;
            text-color: @normal-foreground;
            margin: 1px;
        }
        inputbar {
            children:   [ prompt,textbox-prompt-colon,entry,case-indicator ];
        }
        textbox-prompt-colon {
            expand:     false;
            str:        ":";
            margin:     0px 0.3em 0em 0em ;
            text-color: @normal-foreground;
        }
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
