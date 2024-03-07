{ config, pkgs, ... }:

{
  imports =
    [ # Include X settings.
      ../.
    ];

  # Enable Gnome and GDM.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  security.pam.services.gdm.enableKwallet = true;

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  services.gnome.tracker-miners.enable = true;

  environment.systemPackages = with pkgs; [
    fractal
    gnome.gnome-software
    gnomeExtensions.appindicator
    gnomeExtensions.blur-my-shell
    gnomeExtensions.gsconnect
    gnomeExtensions.night-theme-switcher
    gnomeExtensions.noannoyance-fork
    gnomeExtensions.tailscale-status
    gnomeExtensions.tiling-assistant
    # pkgs.libsForQt5.kwalletmanager
  ];

  services.flatpak.packages = [
    "com.github.tchx84.Flatseal"
  ];

  # Prefer baset set of gnome apps from Flatpaks.
  # environment.gnome.excludePackages = (with pkgs; [
  #   baobab
  #   epiphany
  #   evince
  #   gnome-connections
  #   gnome-photos
  #   gnome-text-editor
  #   gnome-tour
  #   loupe
  #   snapshot # webcam tool
  # ]) ++ (with pkgs.gnome; [
  #   geary # email reader
  #   gnome-calculator
  #   gnome-calendar
  #   gnome-characters
  #   gnome-clocks
  #   gnome-contacts
  #   gnome-logs
  #   gnome-music
  #   gnome-weather
  #   sushi
  #   totem # video player
  # ]);


  #   "org.gnome.baobab"
  #   "org.gnome.Builder"
  #   "  # services.flatpak.packages = [
  #   "com.github.tchx84.Flatseal"org.gnome.Calculator"
  #   "org.gnome.Characters"
  #   "org.gnome.clocks"
  #   "org.gnome.Connections"
  #   "org.gnome.Contacts"
  #   "org.gnome.Epiphany"
  #   "org.gnome.Evince"
  #   "org.gnome.Fractal"
  #   "org.gnome.Geary"
  #   "org.gnome.Logs"
  #   "org.gnome.Loupe"
  #   "org.gnome.Music"
  #   "org.gnome.NautilusPreviewer"
  #   "org.gnome.Photos"
  #   "org.gnome.Snapshot"
  #   "org.gnome.TextEditor"
  #   "org.gnome.Totem"
  #   "org.gnome.Weather"
  #   "org.gnome.Calendar"
  # ];

  nixpkgs.overlays = [
    (final: prev: {
      gnome = prev.gnome.overrideScope (gnomeFinal: gnomePrev: {
        mutter = gnomePrev.mutter.overrideAttrs ( old: {
          src = pkgs.fetchgit {
            url = "https://gitlab.gnome.org/vanvugt/mutter.git";
            # GNOME 45: triple-buffering-v4-45
            rev = "0b896518b2028d9c4d6ea44806d093fd33793689";
            sha256 = "sha256-mzNy5GPlB2qkI2KEAErJQzO//uo8yO0kPQUwvGDwR4w=";
          };
        } );
      });
    })
  ];
}
