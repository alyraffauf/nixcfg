{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.desktop.gnome.enable =
      lib.mkEnableOption "Enables GNOME with basic settings configuration.";
  };

  config = lib.mkIf config.alyraffauf.desktop.gnome.enable {
    dconf.enable = true;
    dconf.settings = {
      "org/gnome/desktop/datetime".automatic-timezone = true;
      "org/gnome/desktop/interface".clock-format = "12h";
      "org/gnome/desktop/interface".enable-hot-corners = true;
      "org/gnome/desktop/peripherals/touchpad".tap-to-click = true;
      "org/gnome/desktop/search-providers".enabled = "['org.gnome.Calendar.desktop', 'org.gnome.Weather.desktop', 'org.gnome.Contacts.desktop', 'org.gnome.Calculator.desktop', 'org.gnome.Characters.desktop', 'org.gnome.clocks.desktop']";
      "org/gnome/desktop/wm/preferences".auto-raise = true;
      "org/gnome/mutter".dynamic-workspaces = true;
      "org/gnome/mutter".edge-tiling = true;
      "org/gnome/mutter".workspaces-only-on-primary = true;
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
      "org/gnome/shell/extensions/blur-my-shell/panel".blur = false;
      "org/gnome/shell/extensions/blur-my-shell/panel".customize = true;
      "org/gnome/shell/extensions/blur-my-shell/panel".override-background = false;
      "org/gnome/shell/extensions/blur-my-shell/panel".override-background-dynamically = false;
      "org/gnome/shell/extensions/blur-my-shell/panel".style-panel = 0;
      "org/gnome/shell/extensions/blur-my-shell/panel".unblur-in-overview = true;
      "org/gnome/system/location".enabled = true;
      "org/gtk/gtk4/settings/file-chooser".sort-directories-first = true;
      "org/gtk/settings/file-chooser".sort-directories-first = true;
    };
  };
}
