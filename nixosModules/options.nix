{
  config,
  lib,
  ...
}: {
  options.ar = {
    apps = {
      emudeck.enable = lib.mkEnableOption "EmuDeck emulator manager.";
      firefox.enable = lib.mkEnableOption "Firefox Web Browser.";
      nicotine-plus.enable = lib.mkEnableOption "Nicotine+ Soulseek client.";
      podman.enable = lib.mkEnableOption "Podman for OCI container support.";
      steam.enable = lib.mkEnableOption "Valve's Steam for video games.";
      virt-manager.enable = lib.mkEnableOption "Virtual machine client.";
    };

    desktop = {
      greetd = {
        enable = lib.mkEnableOption "Greetd display manager.";

        autologin = lib.mkOption {
          description = "User to autologin.";
          default = null;
          type = lib.types.nullOr lib.types.str;
        };

        session = lib.mkOption {
          description = "Default command to execute on login.";
          default = lib.getExe config.programs.hyprland.package;
          type = lib.types.str;
        };
      };

      gnome.enable = lib.mkEnableOption "GNOME desktop session.";
      hyprland.enable = lib.mkEnableOption "Hyprland wayland session.";
      kde.enable = lib.mkEnableOption "KDE desktop session.";
      steam.enable = lib.mkEnableOption "Steam + Gamescope session.";
    };

    laptopMode = lib.mkEnableOption "Enable laptop configuration.";

    services.flatpak.enable = lib.mkEnableOption "Flatpak support with GUI.";
  };
}
