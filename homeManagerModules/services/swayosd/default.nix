{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.ar.home;
in {
  config = lib.mkIf cfg.services.swayosd.enable {
    home.packages = with pkgs; [
      swayosd
    ];

    services.swayosd = {
      enable = lib.mkDefault true;
      stylePath = "${config.xdg.configHome}/swayosd/style.css";
    };

    systemd.user.services.swayosd = {
      Install.WantedBy = lib.mkForce (lib.optional (cfg.desktop.hyprland.enable) "hyprland-session.target" ++ lib.optional (cfg.desktop.sway.enable) "sway-session.target");
      Service.Restart = lib.mkForce "no";
      Unit.BindsTo = lib.optional (cfg.desktop.hyprland.enable) "hyprland-session.target" ++ lib.optional (cfg.desktop.sway.enable) "sway-session.target";
    };

    xdg.configFile."swayosd/style.css" = {
      text = ''
        window#osd {
          padding: 12px 20px;
          border-radius: ${toString cfg.theme.borderRadius}px;
          border: 4px solid alpha(${cfg.theme.colors.primary}, 0.8);
          background: alpha(${cfg.theme.colors.background}, 0.8);
        }

        window#osd #container {
          margin: 16px;
        }

        window#osd image,
        window#osd label {
          color: ${cfg.theme.colors.secondary};
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
          background: alpha(${cfg.theme.colors.secondary}, 0.5);
        }

        window#osd progress {
          min-height: inherit;
          border-radius: inherit;
          border: none;
          background: ${cfg.theme.colors.secondary};
        }
      '';

      onChange = ''
        ${lib.getExe' pkgs.systemd "systemctl"} restart --user swayosd
      '';
    };
  };
}
