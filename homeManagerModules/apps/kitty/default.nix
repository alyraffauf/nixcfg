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

      settings = {
        confirm_os_window_close = "0";
        notify_on_cmd_finish = "unfocused 10.0 command ${lib.getExe pkgs.libnotify} -i ${pkgs.kitty}/share/icons/hicolor/256x256/apps/kitty.png \"Job Finished\"";
        tab_bar_style = "powerline";
        window_padding_width = 5;
      };
    };
  };
}
