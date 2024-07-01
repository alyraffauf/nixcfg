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
          font-family: "${config.ar.home.theme.font.name}", sans-serif;
          background-image: none;
          box-shadow: none;
          transition: 20ms;
        }

        window {
          background-color: rgba(35, 38, 52, 0.8);
        }

        button {
          margin: 5px;
          border-radius: 10;
          border-color: ${config.ar.home.theme.colors.primary};
          text-decoration-color: ${config.ar.home.theme.colors.text};
          color: ${config.ar.home.theme.colors.text};
          background-color: ${config.ar.home.theme.colors.background};
          border-style: solid;
          border-width: 2;
          background-repeat: no-repeat;
          background-position: center;
          background-size: 25%;
        }

        button:focus, button:active, button:hover {
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
