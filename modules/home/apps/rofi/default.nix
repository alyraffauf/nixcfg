{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myHome;

  inherit (config.lib.formats.rasi) mkLiteral;
  mkRgba = opacity: color: let
    c = config.lib.stylix.colors;
    r = c."${color}-rgb-r";
    g = c."${color}-rgb-g";
    b = c."${color}-rgb-b";
  in
    mkLiteral
    "rgba ( ${r}, ${g}, ${b}, ${opacity} % )";
  mkRgb = mkRgba "100";
  rofiOpacity = builtins.toString (builtins.ceil (config.stylix.opacity.popups * 100));
in {
  options.myHome.programs.rofi.enable = lib.mkEnableOption "Rofi launcher.";

  config = lib.mkIf cfg.programs.rofi.enable {
    home.packages = [
      pkgs.networkmanager_dmenu
      pkgs.rofi-rbw-wayland
    ];

    stylix.targets.rofi.enable = false;

    programs.rofi = {
      enable = true;
      font = "${config.stylix.fonts.monospace.name} ${toString config.stylix.fonts.sizes.popups}";
      location = "center";
      package = pkgs.rofi-wayland;

      plugins = [
        pkgs.rofi-power-menu
      ];

      terminal = lib.getExe cfg.defaultApps.terminal;
      theme = {
        "*" = {
          background = mkRgba rofiOpacity "base00";
          lightbg = mkRgba rofiOpacity "base01";
          red = mkRgba rofiOpacity "base08";
          blue = mkRgba rofiOpacity "base0D";
          blueopaque = mkRgb "base0D";
          lightfg = mkRgba rofiOpacity "base06";
          foreground = mkRgb "base05";
          lightbgopaque = mkRgb "base01";
          lightfgopaque = mkRgb "base06";

          background-color = mkLiteral "transparent";
          separatorcolor = mkLiteral "@blueopaque";
          border-color = mkLiteral "@foreground";
          selected-normal-foreground = mkLiteral "@lightbgopaque";
          selected-normal-background = mkLiteral "@blueopaque";
          selected-active-foreground = mkLiteral "@lightbgopaque";
          selected-active-background = mkLiteral "@blueopaque";
          selected-urgent-foreground = mkLiteral "@background";
          selected-urgent-background = mkLiteral "@red";
          normal-foreground = mkLiteral "@foreground";
          normal-background = mkLiteral "transparent";
          active-foreground = mkLiteral "@blue";
          active-background = mkLiteral "transparent";
          urgent-foreground = mkLiteral "@red";
          urgent-background = mkLiteral "transparent";
          alternate-normal-foreground = mkLiteral "@foreground";
          alternate-normal-background = mkLiteral "transparent";
          alternate-active-foreground = mkLiteral "@blue";
          alternate-active-background = mkLiteral "transparent";
          alternate-urgent-foreground = mkLiteral "@red";
          alternate-urgent-background = mkLiteral "transparent";

          # Text Colors
          base-text = mkRgb "base05";
          selected-normal-text = mkRgb "base01";
          selected-active-text = mkRgb "base00";
          selected-urgent-text = mkRgb "base00";
          normal-text = mkRgb "base05";
          active-text = mkRgb "base0D";
          urgent-text = mkRgb "base08";
          alternate-normal-text = mkRgb "base05";
          alternate-active-text = mkRgb "base0D";
          alternate-urgent-text = mkRgb "base08";
        };

        window = {
          background-color = mkLiteral "@background";
          border = 4;
          border-color = mkLiteral "@blue";
          border-radius = mkLiteral "${toString cfg.theme.borders.radius}";
        };

        message = {
          border-color = mkLiteral "@separatorcolor";
          border = mkLiteral "2px solid 0px 0px";
          padding = 1;
        };

        textbox.text-color = mkLiteral "@base-text";

        listview = {
          border = mkLiteral "2px solid 0px 0px";
          border-color = mkLiteral "@separatorcolor";
          # border-radius = cfg.theme.borders.radius;
          padding = 5;
          scrollbar = false;
          spacing = 4;
        };

        element = {
          border = 0;
          border-radius = cfg.theme.borders.radius;
          padding = 5;
        };

        element-text = {
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
        };

        element-icon = {
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
        };

        "element normal.normal" = {
          background-color = mkLiteral "@normal-background";
          text-color = mkLiteral "@normal-text";
        };

        "element normal.urgent" = {
          background-color = mkLiteral "@urgent-background";
          text-color = mkLiteral "@urgent-text";
        };

        "element normal.active" = {
          background-color = mkLiteral "@active-background";
          text-color = mkLiteral "@active-text";
        };

        "element selected.normal" = {
          background-color = mkLiteral "@selected-normal-background";
          text-color = mkLiteral "@selected-normal-text";
        };

        "element selected.urgent" = {
          background-color = mkLiteral "@selected-urgent-background";
          text-color = mkLiteral "@selected-urgent-text";
        };

        "element selected.active" = {
          background-color = mkLiteral "@selected-active-background";
          text-color = mkLiteral "@selected-active-text";
        };

        "element alternate.normal" = {
          background-color = mkLiteral "@alternate-normal-background";
          text-color = mkLiteral "@alternate-normal-text";
        };

        "element alternate.urgent" = {
          background-color = mkLiteral "@alternate-urgent-background";
          text-color = mkLiteral "@alternate-urgent-text";
        };

        "element alternate.active" = {
          background-color = mkLiteral "@alternate-active-background";
          text-color = mkLiteral "@alternate-active-text";
        };

        scrollbar.handle-color = mkLiteral "@normal-foreground";
        sidebar.border-color = mkLiteral "@separatorcolor";
        button.text-color = mkLiteral "@normal-text";

        "button selected" = {
          background-color = mkLiteral "@selected-normal-background";
          text-color = mkLiteral "@selected-normal-text";
        };

        inputbar.text-color = mkLiteral "@normal-text";
        case-indicator.text-color = mkLiteral "@normal-text";
        entry.text-color = mkLiteral "@normal-text";
        prompt.text-color = mkLiteral "@normal-text";

        "#textbox-prompt-colon" = {
          expand = false;
          margin = mkLiteral "0px 0.3em 0em 0em";
          str = ":";
          text-color = mkLiteral "inherit";
        };

        case-indicator.spacing = 0;
        entry.spacing = 0;

        prompt = {
          spacing = 0;
          margin = 1;
        };

        "#inputbar" = {
          children = map mkLiteral ["prompt" "textbox-prompt-colon" "entry" "case-indicator"];
          padding = 10;
        };

        mode-switcher = {
          border = mkLiteral "2px solid 0px 0px";
          border-color = mkLiteral "@separatorcolor";
        };
      };

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
        clear-after 60
        prompt "Bitwarden"
        typing-key-delay 30
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
