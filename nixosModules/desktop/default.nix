{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./gnome
    ./greetd
    ./hyprland
    ./lightdm
    ./plasma
    ./sway
  ];

  options = {
    alyraffauf.desktop.enable =
      lib.mkEnableOption "Enable basic GUI X11 and Wayland environment.";
  };

  config = lib.mkIf config.alyraffauf.desktop.enable {
    services = {
      gnome.gnome-keyring.enable = true;
      gvfs.enable = true; # Mount, trash, etc.
      # Enable the X11 windowing system.
      xserver = {
        enable = true;
        xkb.layout = "us";
        xkb.variant = "";
        excludePackages = with pkgs; [xterm];
      };
    };

    # Install pretty fonts.
    fonts.packages = with pkgs; [
      liberation_ttf
      (nerdfonts.override {
        fonts = ["DroidSansMono" "FiraCode" "FiraMono" "Hack" "Noto"];
      })
    ];
  };
}
