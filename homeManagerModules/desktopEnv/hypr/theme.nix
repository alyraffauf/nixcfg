{ pkgs, lib, config, ... }: {

  options = {
    desktopEnv.hyprland.theme.enable =
      lib.mkEnableOption "Hyprland GTK and Qt themes.";
  };

  config = lib.mkIf config.desktopEnv.hyprland.theme.enable {

    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.catppuccin-cursors.frappeDark;
      name = "Catppuccin-Frappe-Dark-Cursors";
      size = 24;
    };

    qt = {
      enable = true;
      platformTheme = "gtk";
      style.name = "gtk2";
    };

    gtk = {
      enable = true;

      theme = {
        package = pkgs.catppuccin-gtk.override {
          accents = [ "mauve" ];
          size = "compact";
          variant = "frappe";
          tweaks = [ "normal" ];
        };
        name = "Catppuccin-Frappe-Compact-Mauve-Dark";
      };

      iconTheme = {
        package = pkgs.catppuccin-papirus-folders.override {
          flavor = "frappe";
          accent = "mauve";
        };
        name = "Papirus-Dark";
      };

      font = {
        name = "NotoSans Nerd Font Regular";
        package = pkgs.nerdfonts.override { fonts = [ "Noto" ]; };
        size = 11;
      };

      gtk3.extraConfig = { gtk-application-prefer-dark-theme = 1; };

      gtk4.extraConfig = { gtk-application-prefer-dark-theme = 1; };

    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        gtk-theme = "Catppuccin-Frappe-Compact-Mauve-Dark";
        color-scheme = "prefer-dark";
        cursor-theme = "Catppuccin-Frappe-Dark-Cursors";
        cursor-size = 24;
      };
    };
  };
}
