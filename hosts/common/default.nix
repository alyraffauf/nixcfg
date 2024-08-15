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
    image = ../../_img/hyprland.png;
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
      applications = 0.8;
      desktop = 0.8;
      terminal = 0.8;
    };
  };
}
