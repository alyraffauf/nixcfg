{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf (config.ar.home.desktop.hyprland.enable || config.ar.home.desktop.sway.enable) {
    ar.home = {
      apps = {
        kitty.enable = lib.mkDefault true;
        rofi.enable = lib.mkDefault true;
        swaylock.enable = lib.mkDefault true;
      };

      services = {
        mako.enable = lib.mkDefault true;
        pipewire-inhibit.enable = lib.mkDefault true;
        swayidle.enable = lib.mkDefault true;
        waybar.enable = lib.mkDefault true;
      };
    };

    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/wm/preferences".button-layout = "";
        "org/gnome/nm-applet".disable-connected-notifications = true;
      };
    };

    home.packages = with pkgs; [
      blueberry
      gnome.file-roller
      libnotify
      networkmanagerapplet
      swayosd
    ];

    services = {
      playerctld.enable = lib.mkDefault true;
      swayosd = {
        enable = lib.mkDefault true;
        stylePath = "${config.xdg.configHome}/swayosd/style.css";
      };
    };

    xdg.configFile."swayosd/style.css" = {
      text = ''
        window#osd {
          padding: 12px 20px;
          border-radius: ${toString config.ar.home.theme.borderRadius}px;
          border: 4px solid alpha(${config.ar.home.theme.colors.primary}, 0.8);
          background: alpha(${config.ar.home.theme.colors.background}, 0.8);
        }
        window#osd #container {
          margin: 16px;
        }
        window#osd image,
        window#osd label {
          color: ${config.ar.home.theme.colors.secondary};
        }
        window#osd progressbar:disabled,
        window#osd image:disabled {
          opacity: 0.5;
        }
        window#osd progressbar {
          min-height: 6px;
          border-radius: 999px;
          background: transparent;
          border: none;
        }
        window#osd trough {
          min-height: inherit;
          border-radius: inherit;
          border: none;
          background: alpha(${config.ar.home.theme.colors.secondary}, 0.5);
        }
        window#osd progress {
          min-height: inherit;
          border-radius: inherit;
          border: none;
          background: ${config.ar.home.theme.colors.secondary};
        }
      '';

      onChange = ''
        ${lib.getExe' pkgs.systemd "systemctl"} restart --user swayosd
      '';
    };

    systemd.user.services.swayosd = {
      Install.WantedBy = lib.mkForce ["hyprland-session.target" "sway-session.target"];
      Service = {
        Restart = lib.mkForce "on-failure";
        RestartSec = 5;
      };
    };

    xdg.portal = {
      enable = true;
      configPackages =
        lib.optional (config.ar.home.desktop.hyprland.enable) pkgs.xdg-desktop-portal-hyprland;
      extraPortals =
        [pkgs.xdg-desktop-portal-gtk]
        ++ lib.optional (config.ar.home.desktop.hyprland.enable) pkgs.xdg-desktop-portal-hyprland;
    };
  };
}
