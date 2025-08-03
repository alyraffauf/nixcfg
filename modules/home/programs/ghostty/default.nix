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

      settings = {
        gtk-single-instance = lib.mkIf pkgs.stdenv.isLinux true;
        quit-after-last-window-closed = lib.mkIf pkgs.stdenv.isLinux false;
      };
    };
  };
}
