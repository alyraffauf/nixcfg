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
          action = "${pkgs.systemd}/bin/loginctl terminate-user ${config.home.username}";
          text = "Logout";
          keybind = "e";
        }
        {
          label = "shutdown";
          action = "${pkgs.systemd}/bin/systemctl poweroff";
          text = "Shutdown";
          keybind = "s";
        }
        {
          label = "reboot";
          action = "${pkgs.systemd}/bin/systemctl reboot";
          text = "Reboot";
          keybind = "r";
        }
      ];
    };
  };
}
