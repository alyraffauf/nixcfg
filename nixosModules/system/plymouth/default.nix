{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.system.plymouth.enable =
      lib.mkEnableOption
      "Enables plymouth boot screen with reduced text verbosity.";
  };

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
