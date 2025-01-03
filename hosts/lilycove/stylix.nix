{
  pkgs,
  self,
  ...
}: {
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-latte.yaml";
    image = "${self.inputs.wallpapers}/wallhaven-yxdrex.png";
    imageScalingMode = "fill";
    polarity = "light";

    cursor = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
    };

    fonts = {
      monospace = {
        name = "CaskaydiaCove Nerd Font";
        package = pkgs.nerd-fonts.caskaydia-cove;
      };

      sansSerif = {
        name = "UbuntuSans Nerd Font";
        package = pkgs.nerd-fonts.ubuntu-sans;
      };

      serif = {
        name = "Source Serif Pro";
        package = pkgs.source-serif-pro;
      };

      sizes = {
        applications = 12;
        desktop = 11;
        popups = 12;
        terminal = 13;
      };
    };

    opacity = {
      applications = 1.0;
      desktop = 0.8;
      terminal = 0.8;
      popups = 0.8;
    };
  };
}
