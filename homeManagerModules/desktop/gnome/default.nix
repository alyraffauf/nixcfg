{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.ar.home.desktop.gnome.enable {
    dconf.enable = true;

    dconf.settings = {
      "org/gnome/desktop/datetime".automatic-timezone = true;

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

      "org/gnome/settings-daemon/plugins/color" = {
        # night-light-enabled = true;
      };

      "org/gnome/shell".enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "blur-my-shell@aunetx"
        "gsconnect@andyholmes.github.io"
        "nightthemeswitcher@romainvigier.fr"
        "noannoyance-fork@vrba.dev"
        "tailscale-status@maxgallup.github.com"
        "tiling-assistant@leleat-on-github"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
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

      "org/gnome/system/location".enabled = true;
    };

    xdg.mimeApps = {
      enable = true;

      defaultApplications = {
        "x-scheme-handler/sms" = "org.gnome.Shell.Extensions.GSConnect.desktop";
        "x-scheme-handler/tel" = "org.gnome.Shell.Extensions.GSConnect.desktop";
      };
    };
  };
}
