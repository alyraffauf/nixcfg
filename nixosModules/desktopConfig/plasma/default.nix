{ pkgs, lib, config, ... }: {

  options = {
    desktopConfig.plasma.enable =
      lib.mkEnableOption "Enables plasma desktop session.";
  };

  config = lib.mkIf config.desktopConfig.plasma.enable {
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
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.sddm.enableGnomeKeyring = true;
  };
}
