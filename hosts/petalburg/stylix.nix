{pkgs, ...}: {
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";

    image = let
      wallpapers = builtins.fetchGit {
        url = "https://github.com/alyraffauf/wallpapers.git";
        rev = "c7d61966e339dd7efdda5ff176b91778086ccb73";
        ref = "master";
      };
    in "${wallpapers}/wallhaven-jxp18w.jpg";

    imageScalingMode = "fill";
    polarity = "dark";

    cursor = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
    };

    fonts = {
      monospace = {
        name = "UbuntuSansMono Nerd Font";
        package = pkgs.nerdfonts.override {fonts = ["UbuntuSans"];};
      };

      sansSerif = {
        name = "UbuntuSans Nerd Font";
        package = pkgs.nerdfonts.override {fonts = ["UbuntuSans"];};
      };

      serif = {
        name = "Vegur";
        package = pkgs.vegur;
      };

      sizes = {
        applications = 11;
        desktop = 10;
        popups = 11;
        terminal = 12;
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
