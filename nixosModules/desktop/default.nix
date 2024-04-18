{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [./gnome ./hyprland ./lightdm ./plasma];

  options = {
    desktop.enable =
      lib.mkEnableOption "Enable basic GUI X11 and Wayland environment.";
  };

  config = lib.mkIf config.desktop.enable {
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

    desktop.hyprland.enable = lib.mkDefault true;
  };
}
