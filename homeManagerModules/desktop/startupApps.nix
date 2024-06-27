{
  pkgs,
  lib,
  config,
  ...
}: {
  ## Hyprland
  wayland.windowManager.hyprland.extraConfig = ''
    ${
      lib.strings.concatMapStringsSep
      "\n"
      (app: "exec-once = sleep 1 && ${app}")
      config.ar.home.desktop.startupApps
    }
  '';

  ## Sway

  # dconf = {
  #   enable = true;
  #   settings = {
  #   };
  # };
}
