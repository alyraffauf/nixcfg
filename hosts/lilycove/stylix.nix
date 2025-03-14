{
  pkgs,
  self,
  ...
}: {
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    image = "${self.inputs.wallpapers}/wallhaven-rr9qzw.png";
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
        applications = 10;
        desktop = 9;
        popups = 10;
        terminal = 10;
      };
    };

    opacity = {
      applications = 1.0;
      desktop = 0.8;
      terminal = 1.0;
      popups = 0.8;
    };
  };
}
