{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.ghostty = {
    enable = true;
    package = lib.mkIf pkgs.stdenv.isDarwin null;

    settings = {
      font-size = lib.mkForce (toString (config.stylix.fonts.sizes.terminal + 4));
    };
  };
}
