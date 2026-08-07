{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.services.swayosd.enable = lib.mkEnableOption "swayosd brightness/sound controls";

  config = lib.mkIf config.myHome.services.swayosd.enable {
    home.packages = with pkgs; [
      swayosd
    ];

    services.swayosd.enable = lib.mkDefault true;

    systemd.user.services.swayosd = {
      Install.WantedBy = lib.mkForce (lib.optional config.wayland.windowManager.hyprland.enable "hyprland-session.target");
      Service.Restart = lib.mkForce "no";
      Unit.BindsTo = lib.optional config.wayland.windowManager.hyprland.enable "hyprland-session.target";
    };
  };
}
