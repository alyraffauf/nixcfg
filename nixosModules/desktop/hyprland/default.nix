{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.desktop.hyprland.enable {
    nix.settings = {
      auto-optimise-store = false;

      substituters = [
        "https://hyprland.cachix.org"
        "https://cache.nixos.org/"
      ];

      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };

    nixpkgs.overlays = [
      (final: prev: {
        hyprland = inputs.hyprland.packages.${pkgs.system}.hyprland;
        xdg-desktop-portal-hyprland = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
      })
    ];

    programs = {
      hyprland = {
        enable = true;
        package = pkgs.hyprland;
      };
    };
  };
}
