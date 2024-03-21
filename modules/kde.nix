{ config, pkgs, ... }:

{
  imports =
    [ # Include X settings.
      ./desktop.nix
    ];

  # Enable SDDM + Plasma Desktop.
  services = {
    desktopManager.plasma6.enable = true;
    xserver = {
      displayManager.sddm = {
        wayland.enable = true;
        enableHidpi = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    kdePackages.kate
    kdePackages.kimageformats
    kdePackages.kio-gdrive
    kdePackages.sddm-kcm
    maliit-keyboard
    nheko
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.kdeconnect.enable = true;
#   nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;
#   nixpkgs.config.chromium.commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto";
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
}
