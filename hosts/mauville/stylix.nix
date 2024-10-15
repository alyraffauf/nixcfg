{
  pkgs,
  self,
  ...
}: {
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-light-hard.yaml";
    image = "${self.inputs.wallpapers}/wallhaven-3lyrvy.png";
    imageScalingMode = "fill";
    polarity = "light";

    cursor = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
    };

    fonts = {
      monospace = {
        name = "CaskaydiaCove Nerd Font";
        package = pkgs.nerdfonts.override {fonts = ["CascadiaCode"];};
      };

      sansSerif = {
        name = "UbuntuSans Nerd Font";
        package = pkgs.nerdfonts.override {fonts = ["UbuntuSans"];};
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
