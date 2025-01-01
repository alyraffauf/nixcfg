{...}: {
  programs.dconf.profiles.gdm.databases = [
    {
      settings = {
        "org/gnome/desktop/peripherals/keyboard" = {
          numlock-state = true;
          remember-numlock-state = true;
        };

        "org/gnome/desktop/peripherals/touchpad" = {
          tap-to-click = true;
        };
      };
    }
  ];

  security.pam.services.gdm = {
    enableGnomeKeyring = true;
    gnupg.enable = true;
    kwallet.enable = true;
  };

  services.xserver.displayManager.gdm.enable = true;
}
