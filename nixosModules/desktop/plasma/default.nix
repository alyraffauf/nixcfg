{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.desktop.plasma.enable =
      lib.mkEnableOption "Enable plasma desktop session.";
  };

  config = lib.mkIf config.alyraffauf.desktop.plasma.enable {
    # Enable SDDM + Plasma Desktop.
    services = {
      desktopManager.plasma6.enable = true;
      xserver = {
        displayManager.sddm = {
          enable = true;
          wayland.enable = true;
        };
      };
    };

    environment.systemPackages = with pkgs; [
      kdePackages.kate
      kdePackages.kimageformats
      kdePackages.kio-gdrive
      kdePackages.sddm-kcm
      maliit-keyboard
    ];

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    programs.kdeconnect.enable = true;
    #   nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;
    #   nixpkgs.config.chromium.commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto";
    security.pam.services.sddm.enableGnomeKeyring = true;
  };
}
