{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.desktop.lightdm.enable {
    security.pam.services.lightdm = {
      enableGnomeKeyring = true;
      gnupg.enable = true;
      kwallet.enable = true;
    };

    services.xserver.displayManager.lightdm = {
      enable = true;
      greeters.slick = {
        enable = true;
        theme = {
          name = "catppuccin-frappe-mauve-compact+normal";
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
          name = "catppuccin-frappe-dark-cursors";
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
