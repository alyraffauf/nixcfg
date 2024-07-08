{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.ar.desktop.cinnamon.enable {
    security.pam.services.lightdm = {
      enableGnomeKeyring = true;
      gnupg.enable = true;
      kwallet.enable = true;
    };

    services = {
      xserver = {
        enable = true;
        desktopManager.cinnamon.enable = true;

        displayManager.lightdm = {
          enable = true;
          greeters.slick = {
            enable = true;

            cursorTheme = {
              name = "Bibata-Modern-Classic";
              package = pkgs.bibata-cursors;
              size = 20;
            };

            font = {
              name = "NotoSans Nerd Font";
              package = pkgs.nerdfonts.override {fonts = ["Noto"];};
            };

            iconTheme = {
              name = "Papirus-Dark";
              package = pkgs.papirus-icon-theme;
            };

            theme = {
              name = "adw-gtk3-dark";
              package = pkgs.adw-gtk3;
            };

            extraConfig = ''
              background=#242424
              enable-hidpi=on
            '';
          };
        };
      };
    };
  };
}
