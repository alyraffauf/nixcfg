{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.ar.home;
in {
  config = lib.mkIf cfg.apps.gtklock.enable {
    home.packages = with pkgs; [
      gtklock
    ];

    xdg.configFile = {
      "gtklock/config.ini".text = ''
        [main]
        gtk-theme=adw-gtk3-dark
        time-format=%I:%M%p
      '';

      "gtklock/style.css".text = ''
        window {
           background-image: url("${cfg.theme.wallpaper}");
           background-size: cover;
           background-repeat: no-repeat;
           background-position: center;
           background-color: black;
        }

        #clock-label {
          margin-bottom: 50px;
          font-size: 700%;
          font-weight: bold;
          color: ${cfg.theme.colors.text};
        }

        #input-label {
          color: ${cfg.theme.colors.text};
        }
      '';
    };
  };
}
