{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.desktop.defaultApps.enable =
      lib.mkEnableOption "GTK and Qt themes.";
    alyraffauf.desktop.defaultApps.browser = {
      name = lib.mkOption {
        description = "Default web browser executable name.";
        default = "firefox";
        type = lib.types.str;
      };
      desktop = lib.mkOption {
        description = "Default web browser desktop file name.";
        default = "firefox.desktop";
        type = lib.types.str;
      };
      package = lib.mkOption {
        description = "Default web browser package.";
        default = pkgs.firefox;
        type = lib.types.package;
      };
    };
    alyraffauf.desktop.defaultApps.editor = {
      name = lib.mkOption {
        description = "Default editor executable name.";
        default = "codium";
        type = lib.types.str;
      };
      desktop = lib.mkOption {
        description = "Default editor desktop file name.";
        default = "codium.desktop";
        type = lib.types.str;
      };
      package = lib.mkOption {
        description = "Default editor package.";
        default = pkgs.vsCodium;
        type = lib.types.package;
      };
    };
  };

  config = lib.mkIf config.alyraffauf.desktop.theme.enable {
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "application/xhtml+xml" = "firefox.desktop";
        "text/html" = "firefox.desktop";
        "text/xml" = "firefox.desktop";
        "x-scheme-handler/ftp" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
      };
    };
    home.sessionVariables = {
      EDITOR = "${lib.getExe pkgs.neovim}";
      BROWSER = "${lib.getExe pkgs.firefox}";
      TERMINAL = "${lib.getExe pkgs.kitty}";
    };
  };
}
