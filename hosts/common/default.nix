{pkgs, ...}: {
  imports = [
    ./locale.nix
    ./network.nix
    ./nix.nix
    ./pipewireFix.nix
    ./samba.nix
    ./secrets.nix
  ];

  environment.systemPackages = with pkgs; [git inxi python3];

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-moon.yaml";

    image = let
      wallpapers = builtins.fetchGit {
        url = "https://github.com/alyraffauf/wallpapers.git";
        rev = "21018eef106928c7c44d206c6c3730cce5f781f3";
        ref = "master";
      };
    in "${wallpapers}/wallhaven-mp886k.jpg";

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
    };

    opacity = {
      applications = 1.0;
      desktop = 0.8;
      terminal = 0.8;
      popups = 0.8;
    };
  };
}
