{ pkgs, lib, config, ... }: {

  options = {
    desktopConfig.displayManagers.lightdm.enable = lib.mkEnableOption
      "Enables lightdm and slick greeter with Catppuccin theme.";
  };

  config = lib.mkIf config.desktopConfig.displayManagers.lightdm.enable {
    services.xserver.displayManager.lightdm = {
      enable = true;
      greeters.slick = {
        enable = true;
        theme.name = "Catppuccin-Frappe-Compact-Mauve-Dark";
        theme.package = pkgs.catppuccin-gtk.override {
          accents = [ "mauve" ];
          size = "compact";
          variant = "frappe";
          tweaks = [ "normal" ];
        };

        iconTheme.name = "Papirus-Dark";
        iconTheme.package = pkgs.catppuccin-papirus-folders.override {
          flavor = "frappe";
          accent = "mauve";
        };

        font.name = "NotoSans Nerd Font Regular";
        font.package = pkgs.nerdfonts.override { fonts = [ "Noto" ]; };

        cursorTheme.package = pkgs.catppuccin-cursors.frappeDark;
        cursorTheme.name = "Catppuccin-Frappe-Dark-Cursors";
        cursorTheme.size = 32;

        extraConfig = ''
          background=#ca9ee6
          enable-hidpi=on
        '';
      };
    };
  };
}
