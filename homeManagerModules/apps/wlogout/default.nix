{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {alyraffauf.apps.wlogout.enable = lib.mkEnableOption "Enables wlogout.";};

  config = lib.mkIf config.alyraffauf.apps.wlogout.enable {
    programs.wlogout = {
      enable = true;
      layout = [
        {
          label = "logout";
          action = ''${lib.getExe' pkgs.systemd "loginctl"} terminate-user ${config.home.username}'';
          text = "Logout";
          keybind = "e";
        }
        {
          label = "shutdown";
          action = ''${lib.getExe' pkgs.systemd "systemctl"} poweroff'';
          text = "Shutdown";
          keybind = "s";
        }
        {
          label = "reboot";
          action = ''${lib.getExe' pkgs.systemd "systemctl"} reboot'';
          text = "Reboot";
          keybind = "r";
        }
      ];
    };
  };
}
