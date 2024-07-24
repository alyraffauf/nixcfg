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
        name = "NotoSansM Nerd Font";
        size = config.gtk.font.size;
      };

      settings = {
        background_opacity = "0.8";
        notify_on_cmd_finish = "unfocused 10.0 command ${lib.getExe pkgs.libnotify} \"Job Finished with Status: %s\" %c";
      };

      theme = "Adwaita dark";
    };
  };
}
