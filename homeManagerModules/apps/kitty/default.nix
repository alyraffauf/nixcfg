{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.home.apps.kitty.enable {
    programs.kitty = {
      enable = true;

      font = {
        name = "UbuntuSansMono Nerd Font";
        size = config.gtk.font.size;
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
