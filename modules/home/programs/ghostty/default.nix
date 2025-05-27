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
      package = lib.mkIf pkgs.stdenv.isDarwin null;

      settings = {
        font-size = lib.mkForce (toString (config.stylix.fonts.sizes.terminal + 2));
        gtk-single-instance = lib.mkIf pkgs.stdenv.isLinux true;
        quit-after-last-window-closed = lib.mkIf pkgs.stdenv.isLinux false;
      };
    };
  };
}
