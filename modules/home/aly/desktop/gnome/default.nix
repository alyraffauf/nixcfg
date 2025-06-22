{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.aly.desktop.gnome = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.myHome.desktop.gnome.enable && config.home.username == "aly";
      description = "Enable Aly's GNOME desktop environment.";
    };
  };

  config = lib.mkIf config.myHome.desktop.gnome.enable {
    dconf = {
      enable = true;

      settings = {
        "org/gnome/shell/extensions/auto-move-windows" = {
          application-list = [
            "zen-beta.desktop:1"
            "obsidian.desktop:2"
            "code.desktop:3"
            "thunderbird.desktop:4"
            "signal.desktop:1"
            "vesktop.desktop:1"
            "plexamp.desktop:1"
          ];
        };
      };
    };

    programs.gnome-shell = {
      enable = true;

      extensions = [
        {package = pkgs.gnomeExtensions.vscode-search-provider;}
      ];
    };
  };
}
