{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.ar.desktop.greetd.enable {
    security.pam.services.greetd = {
      enableGnomeKeyring = true;
      gnupg.enable = true;
      kwallet.enable = true;
    };

    programs.regreet = {
      enable = true;

      settings = {
        background.fit =
          if config.stylix.imageScalingMode == "fill"
          then "Fill"
          else "ScaleDown";

        GTK.application_prefer_dark_theme =
          if config.stylix.polarity == "dark"
          then true
          else false;
      };
    };

    services.greetd = {
      enable = true;

      settings.initial_session = lib.mkIf (config.ar.desktop.greetd.autologin != null) {
        command = config.ar.desktop.greetd.session;
        user = config.ar.desktop.greetd.autologin;
      };
    };
  };
}
