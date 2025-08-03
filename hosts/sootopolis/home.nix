{
  pkgs,
  self,
  ...
}: {
  home-manager.users.aly = self.homeConfigurations.aly;

  home-manager.sharedModules = [
    {
      fontix = {
        fonts = {
          monospace = {
            name = "CaskaydiaCove Nerd Font";
            package = pkgs.nerd-fonts.caskaydia-cove;
          };

          sansSerif = {
            name = "Adwaita";
            package = pkgs.adwaita-fonts;
          };

          serif = {
            name = "Source Serif Pro";
            package = pkgs.source-serif-pro;
          };
        };

        sizes = {
          applications = 11;
          desktop = 10;
        };

        font-packages.enable = true;
        fontconfig.enable = true;
        ghostty.enable = true;
        gnome.enable = true;
        gtk.enable = true;
        halloy.enable = true;
        zed-editor.enable = true;
      };
    }
  ];
}
