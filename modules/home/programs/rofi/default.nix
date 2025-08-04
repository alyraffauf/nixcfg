{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myHome;
  defaultApps.terminal = cfg.profiles.defaultApps.terminal.exec or (lib.getExe pkgs.ghostty);
in {
  options.myHome.programs.rofi.enable = lib.mkEnableOption "rofi application launcher";

  config = lib.mkIf config.myHome.programs.rofi.enable {
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

      inherit (defaultApps) terminal;
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
        terminal = ${defaultApps.terminal}
      '';
    };
  };
}
