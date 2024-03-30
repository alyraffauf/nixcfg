{ pkgs, lib, config, ... }: {

  options = { guiApps.wlogout.enable = lib.mkEnableOption "Enables wlogout."; };

  config = lib.mkIf config.guiApps.wlogout.enable {
    programs.wlogout = {
      enable = true;
      layout = [
        {
          label = "logout";
          action = "loginctl terminate-user $USER";
          text = "Logout";
          keybind = "e";
        }
        {
          label = "shutdown";
          action = "systemctl poweroff";
          text = "Shutdown";
          keybind = "s";
        }
        {
          label = "reboot";
          action = "systemctl reboot";
          text = "Reboot";
          keybind = "r";
        }
      ];
    };
  };
}
