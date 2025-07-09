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
        "org/gnome/shell" = {
          favorite-apps = [
            "zen-beta.desktop"
            "thunderbird.desktop"
            "signal.desktop"
            "vesktop.desktop"
            "obsidian.desktop"
            "com.mitchellh.ghostty.desktop"
            "dev.zed.Zed.desktop"
            "plexamp.desktop"
            "org.gnome.Nautilus.desktop"
          ];
        };

        "org/gnome/shell/extensions/auto-move-windows" = {
          application-list = [
            "code.desktop:3"
            "obsidian.desktop:2"
            "plexamp.desktop:1"
            "signal.desktop:1"
            "thunderbird.desktop:4"
            "vesktop.desktop:1"
            "zen-beta.desktop:1"
            "zen-twilight.desktop:1"
          ];
        };
      };
    };

    programs.gnome-shell = {
      enable = true;

      extensions = [
        {package = pkgs.gnomeExtensions.bluetooth-battery-meter;}
        {package = pkgs.gnomeExtensions.vscode-search-provider;}
      ];
    };
  };
}
