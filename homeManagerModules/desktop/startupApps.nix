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
      config.alyraffauf.desktop.startupApps
    }
  '';

  ## Sway

  # dconf = {
  #   enable = true;
  #   settings = {
  #   };
  # };
}
