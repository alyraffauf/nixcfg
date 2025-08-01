{
  pkgs,
  self,
  ...
}: {
  stylix = {
    enable = true;
    autoEnable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    image = "${self.inputs.wallpapers}/wallhaven-yxdrex.png";
    imageScalingMode = "fill";
    polarity = "dark";

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
        name = "Adwaita";
        package = pkgs.adwaita-fonts;
      };

      serif = {
        name = "Source Serif Pro";
        package = pkgs.source-serif-pro;
      };

      sizes = {
        applications = 11;
        desktop = 11;
        popups = 12;
        terminal = 11;
      };
    };

    opacity = {
      applications = 1.0;
      desktop = 1.0;
      terminal = 1.0;
      popups = 1.0;
    };
  };
}
