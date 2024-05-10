{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.desktop.lightdm.enable =
      lib.mkEnableOption
      "Lightdm and slick greeter with Catppuccin theme.";
  };

  config = lib.mkIf config.alyraffauf.desktop.lightdm.enable {
    security.pam.services.lightdm.enableKwallet = true;
    security.pam.services.lightdm.enableGnomeKeyring = true;

    services.xserver.displayManager.lightdm = {
      enable = true;
      greeters.slick = {
        enable = true;
        theme.name = "Catppuccin-Frappe-Compact-Mauve-Dark";
        theme.package = pkgs.catppuccin-gtk.override {
          accents = ["mauve"];
          size = "compact";
          variant = "frappe";
          tweaks = ["normal"];
        };

        iconTheme.name = "Papirus-Dark";
        iconTheme.package = pkgs.catppuccin-papirus-folders.override {
          flavor = "frappe";
          accent = "mauve";
        };

        font.name = "NotoSansNerdFont-Regular";
        font.package = pkgs.nerdfonts.override {fonts = ["Noto"];};

        cursorTheme.package = pkgs.catppuccin-cursors.frappeDark;
        cursorTheme.name = "Catppuccin-Frappe-Dark-Cursors";
        cursorTheme.size = 24;

        extraConfig = ''
          background=#303446
          enable-hidpi=on
        '';
      };
    };
  };
}
