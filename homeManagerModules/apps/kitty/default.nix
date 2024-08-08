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
        background_opacity = "0.8";
        confirm_os_window_close = "0";
        notify_on_cmd_finish = "unfocused 10.0 command ${lib.getExe pkgs.libnotify} -i ${pkgs.kitty}/share/icons/hicolor/256x256/apps/kitty.png \"Job Finished\"";
        tab_bar_style = "powerline";
      };

      theme = "Adwaita dark";
    };
  };
}
