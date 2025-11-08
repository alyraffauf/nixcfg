{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.programs.ghostty.enable = lib.mkEnableOption "ghostty terminal emulator";

  config = lib.mkIf config.myHome.programs.ghostty.enable {
    programs.ghostty = {
      enable = true;
      package = lib.mkIf pkgs.stdenv.isDarwin pkgs.ghostty-bin;

      settings = lib.mkIf pkgs.stdenv.isLinux {
        # gtk-single-instance = true;
        # quit-after-last-window-closed = false;
        theme = "Adwaita Dark";
        # gtk-titlebar = false;
        window-padding-x = 6;
        window-padding-y = 4;
      };
    };
  };
}
