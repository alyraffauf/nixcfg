{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./greetd
    ./hyprland
    ./sway
    ./waylandComp.nix
  ];

  config =
    lib.mkIf (
      config.ar.desktop.hyprland.enable
      || config.ar.desktop.steam.enable
      || config.ar.desktop.sway.enable
    ) {
      environment = {
        sessionVariables.NIXOS_OZONE_WL = "1";
      };

      fonts.packages = with pkgs; [
        (nerdfonts.override {fonts = ["UbuntuSans"];})
        liberation_ttf
        vegur
      ];

      hardware.logitech.wireless = {
        enable = true;
        enableGraphical = true;
      };

      programs.system-config-printer.enable = true;

      services = {
        gnome.gnome-keyring.enable = true;
        gvfs.enable = true; # Mount, trash, etc.

        pipewire = {
          enable = true;

          alsa = {
            enable = true;
            support32Bit = true;
          };

          pulse.enable = true;
        };

        xserver = {
          enable = true;
          excludePackages = with pkgs; [xterm];
        };
      };
    };
}
