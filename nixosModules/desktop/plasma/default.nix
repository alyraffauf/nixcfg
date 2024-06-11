{
  pkgs,
  lib,
  config,
  ...
}: let
  plasmaCsAdjuster = pkgs.writeShellScriptBin "plasma-cs-adjuster" ''
    # Query the Desktop Portal Service for the current color scheme
    color_scheme=$(${lib.getExe' pkgs.kdePackages.qttools "qdbus"} org.freedesktop.portal.Desktop /org/freedesktop/portal/desktop org.freedesktop.portal.Settings.Read org.freedesktop.appearance color-scheme)

    # Check the color scheme and apply the appropriate look and feel
    if [ "$color_scheme" = "1" ]; then
        ${lib.getExe' pkgs.kdePackages.plasma-workspace "plasma-apply-lookandfeel"} -a org.kde.breeze.desktop
    else
        ${lib.getExe' pkgs.kdePackages.plasma-workspace "plasma-apply-lookandfeel"} -a org.kde.breezedark.desktop
    fi
  '';
in {
  config = lib.mkIf config.alyraffauf.desktop.plasma.enable {
    environment.systemPackages = with pkgs;
      [
        kdePackages.kate
        kdePackages.kimageformats
        kdePackages.kio-gdrive
        kdePackages.sddm-kcm
        maliit-keyboard
      ]
      ++ [plasmaCsAdjuster];

    programs.kdeconnect.enable = true;
    security.pam.services.sddm.enableGnomeKeyring = true;
    services = {
      desktopManager.plasma6.enable = true;
      displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
  };
}
