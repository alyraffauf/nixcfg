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
  };
}
