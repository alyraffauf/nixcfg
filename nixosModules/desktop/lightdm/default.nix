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
          name = "adw-gtk3-dark";
          package = pkgs.adw-gtk3;
        };

        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.papirus-icon-theme;
        };

        font = {
          name = "NotoSans Nerd Font Regular";
          package = pkgs.nerdfonts;
        };

        cursorTheme = {
          name = "Bibata-Modern-Classic";
          package = pkgs.bibata-cursors;
          size = 20;
        };

        extraConfig = ''
          background=#242424
          enable-hidpi=on
        '';
      };
    };
  };
}
