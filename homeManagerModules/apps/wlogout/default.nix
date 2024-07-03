{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.ar.home.apps.wlogout.enable {
    programs.wlogout = {
      enable = true;

      layout = [
        {
          label = "logout";
          action = ''${lib.getExe' pkgs.systemd "loginctl"} terminate-user ${config.home.username}'';
          text = "logout (e)";
          keybind = "e";
        }
        {
          label = "shutdown";
          action = ''${lib.getExe' pkgs.systemd "systemctl"} poweroff'';
          text = "shutdown (s)";
          keybind = "s";
        }
        {
          label = "reboot";
          action = ''${lib.getExe' pkgs.systemd "systemctl"} reboot'';
          text = "reboot (r)";
          keybind = "r";
        }
      ];

      style = ''
        * {
          background-image: none;
          box-shadow: none;
          font-family: "${config.gtk.font.name}", sans-serif;
          transition: 20ms;
        }

        window {
          background-color: rgba(35, 38, 52, 0.8);
        }

        button {
          background-color: ${config.ar.home.theme.colors.background};
          background-position: center;
          background-repeat: no-repeat;
          background-size: 25%;
          border-color: ${config.ar.home.theme.colors.primary};
          border-radius: 10;
          border-style: solid;
          border-width: 2;
          color: ${config.ar.home.theme.colors.text};
          margin: 5px;
          text-decoration-color: ${config.ar.home.theme.colors.text};
        }

        button:active, button:hover {
          background-color: ${config.ar.home.theme.colors.primary};
          outline-style: none;
        }

        #lock {
          background-image: image(url("${config.programs.wlogout.package}/share/wlogout/icons/lock.png"), url("/usr/local/share/wlogout/icons/lock.png"));
        }

        #logout {
          background-image: image(url("${config.programs.wlogout.package}/share/wlogout/icons/logout.png"), url("/usr/local/share/wlogout/icons/logout.png"));
        }

        #suspend {
          background-image: image(url("${config.programs.wlogout.package}/share/wlogout/icons/suspend.png"), url("/usr/local/share/wlogout/icons/suspend.png"));
        }

        #hibernate {
          background-image: image(url("${config.programs.wlogout.package}/share/wlogout/icons/hibernate.png"), url("/usr/local/share/wlogout/icons/hibernate.png"));
        }

        #shutdown {
          background-image: image(url("${config.programs.wlogout.package}/share/wlogout/icons/shutdown.png"), url("/usr/local/share/wlogout/icons/shutdown.png"));
        }

        #reboot {
          background-image: image(url("${config.programs.wlogout.package}/share/wlogout/icons/reboot.png"), url("/usr/local/share/wlogout/icons/reboot.png"));
        }
      '';
    };
  };
}
