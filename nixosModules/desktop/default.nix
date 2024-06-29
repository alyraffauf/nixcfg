{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./cinnamon
    ./gnome
    ./greetd
    ./hyprland
    ./lightdm
    ./plasma
    ./sway
    ./waylandComp.nix
  ];

  config =
    lib.mkIf (
      config.ar.desktop.cinnamon.enable
      || config.ar.desktop.gnome.enable
      || config.ar.desktop.hyprland.enable
      || config.ar.desktop.plasma.enable
      || config.ar.desktop.steam.enable
      || config.ar.desktop.sway.enable
    ) {
      environment.sessionVariables.NIXOS_OZONE_WL = "1";

      fonts.packages = with pkgs; [
        liberation_ttf
        nerdfonts
      ];

      services = {
        gnome.gnome-keyring.enable = true;
        gvfs.enable = true; # Mount, trash, etc.
        xserver = {
          enable = true;
          xkb = {
            layout = "us";
            variant = "altgr-intl";
          };
          excludePackages = with pkgs; [xterm];
        };
      };
    };
}
