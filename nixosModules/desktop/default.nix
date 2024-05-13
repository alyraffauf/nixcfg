{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./budgie
    ./cinnamon
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
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

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
        fonts = ["DroidSansMono" "Noto"];
      })
    ];
  };
}
