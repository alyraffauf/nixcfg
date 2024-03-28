{ pkgs, lib, config, ... }: {

  imports = [ # Include X settings.
    ./fprintdFix.nix
    ./tripleBuffering.nix
  ];

  options = {
    desktopConfig.gnome.enable =
      lib.mkEnableOption "Enables GNOME desktop session.";
  };

  config = lib.mkIf config.desktopConfig.gnome.enable {
    environment.systemPackages = with pkgs; [
      gnomeExtensions.appindicator
      gnomeExtensions.blur-my-shell
      gnomeExtensions.gsconnect
      gnomeExtensions.light-shell
      gnomeExtensions.night-theme-switcher
      gnomeExtensions.noannoyance-fork
      gnomeExtensions.tailscale-status
      gnomeExtensions.tiling-assistant
    ];

    # Enable keyring support for KDE apps in GNOME.
    security.pam.services.gdm.enableKwallet = true;

    # Enable GNOME and GDM.
    services = {
      gnome.tracker-miners.enable = true;
      udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
      xserver = {
        desktopManager.gnome.enable = true;
        displayManager.gdm.enable = true;
      };
    };
  };
}
