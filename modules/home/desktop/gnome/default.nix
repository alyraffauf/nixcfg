{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.desktop.gnome.enable = lib.mkEnableOption "GNOME with sane defaults.";

  config = lib.mkIf config.myHome.desktop.gnome.enable {
    dconf = {
      enable = true;

      settings = {
        "org/gnome/desktop/datetime".automatic-timezone = true;
        "org/gnome/desktop/input-sources".xkb-options = ["ctrl:nocaps"];

        "org/gnome/desktop/interface" = {
          clock-format = "12h";
          enable-hot-corners = true;
        };

        "org/gnome/desktop/peripherals/touchpad".tap-to-click = true;
        "org/gnome/desktop/search-providers".enabled = "['org.gnome.Calendar.desktop', 'org.gnome.Weather.desktop', 'org.gnome.Contacts.desktop', 'org.gnome.Calculator.desktop', 'org.gnome.Characters.desktop', 'org.gnome.clocks.desktop']";
        "org/gnome/desktop/wm/preferences".auto-raise = true;

        "org/gnome/mutter" = {
          dynamic-workspaces = true;
          edge-tiling = true;
          workspaces-only-on-primary = true;
        };

        "org/gnome/shell".enabled-extensions = [
          "appindicatorsupport@rgcjonas.gmail.com"
          "blur-my-shell@aunetx"
          "dash-to-dock@micxgx.gmail.com"
          "drive-menu@gnome-shell-extensions.gcampax.github.com"
          "tailscale-status@maxgallup.github.com"
          "tiling-assistant@leleat-on-github"
        ];

        "org/gnome/shell/extensions/blur-my-shell/overview".style-components = 3;

        "org/gnome/shell/extensions/blur-my-shell/panel" = {
          blur = false;
          customize = true;
          override-background = false;
          override-background-dynamically = false;
          style-panel = 0;
          unblur-in-overview = true;
        };

        "org/gnome/shell/extensions/dash-to-dock" = {
          background-color = config.lib.stylix.colors.withHashtag.base01;
          click-action = "minimize";
          custom-background-color = true;
        };

        "org/gnome/system/location".enabled = true;
      };
    };

    programs.gnome-shell = {
      enable = true;

      extensions = [
        {package = pkgs.gnomeExtensions.appindicator;}
        {package = pkgs.gnomeExtensions.blur-my-shell;}
        {package = pkgs.gnomeExtensions.dash-to-dock;}
        {package = pkgs.gnomeExtensions.tailscale-status;}
        {package = pkgs.gnomeExtensions.tiling-assistant;}
      ];
    };
  };
}
