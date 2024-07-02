{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.base.plymouth.enable {
    boot = {
      consoleLogLevel = 0;
      initrd.verbose = false;
      plymouth = {
        enable = true;
        font = "${pkgs.nerdfonts}/share/fonts/truetype/NerdFonts/NotoSansNerdFont-Regular.ttf";
      };
    };
  };
}
