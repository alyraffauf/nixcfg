{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myHome;
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
      Install.WantedBy = lib.mkForce (lib.optional (cfg.desktop.hyprland.enable) "hyprland-session.target");
      Service.Restart = lib.mkForce "no";
      Unit.BindsTo = lib.optional (cfg.desktop.hyprland.enable) "hyprland-session.target";
    };

    xdg.configFile."swayosd/style.css" = {
      text = ''
        window#osd {
          padding: 12px 20px;
          border-radius: ${toString cfg.theme.borders.radius}px;
          border: 4px solid alpha(${config.lib.stylix.colors.withHashtag."base0D"}, ${toString config.stylix.opacity.popups});
          background: alpha(${config.lib.stylix.colors.withHashtag."base01"}, ${toString config.stylix.opacity.popups});
        }

        window#osd #container {
          margin: 16px;
        }

        window#osd image,
        window#osd label {
          color: ${config.lib.stylix.colors.withHashtag."base06"};
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
          background: alpha(${config.lib.stylix.colors.withHashtag."base06"}, 0.5);
        }

        window#osd progress {
          min-height: inherit;
          border-radius: inherit;
          border: none;
          background: ${config.lib.stylix.colors.withHashtag."base06"};
        }
      '';

      onChange = ''
        ${lib.getExe' pkgs.systemd "systemctl"} restart --user swayosd
      '';
    };
  };
}
