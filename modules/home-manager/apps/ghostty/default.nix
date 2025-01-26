{
  config,
  lib,
  ...
}: let
  cfg = config.myHome;
in {
  config = lib.mkIf cfg.apps.ghostty.enable {
    programs.ghostty = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      installVimSyntax = true;
      settings.gtk-titlebar = lib.mkIf config.wayland.windowManager.hyprland.enable false;
    };
  };
}
