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
    security.pam.services.lightdm = {
      enableGnomeKeyring = true;
      enableKwallet = true;
    };

    services.xserver.displayManager.lightdm = {
      enable = true;
      greeters.slick = {
        enable = true;
        theme = {
          name = "Catppuccin-Frappe-Compact-Mauve-Dark";
          package = pkgs.catppuccin-gtk;
        };

        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.catppuccin-papirus-folders;
        };

        font = {
          name = "NotoSans Nerd Font Regular";
          package = pkgs.nerdfonts;
        };

        cursorTheme = {
          name = "Catppuccin-Frappe-Dark-Cursors";
          package = pkgs.catppuccin-cursors.frappeDark;
          size = 24;
        };

        extraConfig = ''
          background=#303446
          enable-hidpi=on
        '';
      };
    };
  };
}
