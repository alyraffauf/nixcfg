{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.system.plymouth.enable {
    boot = {
      consoleLogLevel = 0;
      initrd.verbose = false;
      plymouth = {
        enable = true;
        themePackages = [pkgs.catppuccin-plymouth];
        theme = "catppuccin-frappe";
        font = "${pkgs.nerdfonts}/share/fonts/truetype/NerdFonts/NotoSansNerdFont-Regular.ttf";
      };
    };
  };
}
