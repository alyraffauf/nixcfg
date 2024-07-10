{
  defaultWorkspaces = [1 2 3 4 5 6 7 8 9];

  externalMonitors = {
    homeOffice0 = "desc:LG Electronics LG ULTRAWIDE 311NTAB5M720,preferred,auto,1.25,vrr,2";
    homeOffice1 = "desc:LG Electronics LG IPS QHD 109NTWG4Y865,preferred,-2560x0,auto";
    homeOffice3 = "desc:LG Electronics LG ULTRAWIDE 207NTHM9F673, preferred,auto,1.25,vrr,2";
    homeOffice4 = "desc:LG Electronics LG IPS QHD 207NTVSE5615,preferred,-1152x0,1.25,transform,1";
    workShop = "desc:Guangxi Century Innovation Display Electronics Co. Ltd 27C1U-D 0000000000001,preferred,-2400x0,1.6";
    weWork = "desc:HP Inc. HP 24mh 3CM037248S,preferred,-1920x0,auto";
  };

  laptopMonitors = {
    framework = "desc:BOE 0x095F,preferred,auto,1.566667";
    t440p = "desc:LG Display 0x0569,preferred,auto,1.0";
    yoga9i = "desc:Samsung Display Corp. 0x4152,preferred,auto,2,transform,0";
  };

  layerRules = ''
    # Window-specific rules
    layerrule = blur, waybar
    layerrule = ignorezero, waybar
    layerrule = blur, launcher
    layerrule = blur, notifications
    layerrule = ignorezero, notifications
    layerrule = blur, logout_dialog
    layerrule = blur, swayosd
    layerrule = ignorezero, swayosd
  '';

  modifier = "SUPER";

  windowManagerBinds = {
    down = "d";
    left = "l";
    right = "r";
    up = "u";
    h = "l";
    j = "d";
    k = "u";
    l = "r";
  };

  windowRules = ''
    windowrulev2 = center(1),class:(.blueman-manager-wrapped)
    windowrulev2 = float,class:(.blueman-manager-wrapped)
    windowrulev2 = size 40% 60%,class:(.blueman-manager-wrapped})

    windowrulev2 = center(1),class:(com.github.wwmm.easyeffects)
    windowrulev2 = float,class:(com.github.wwmm.easyeffects)
    windowrulev2 = size 40% 60%,class:(com.github.wwmm.easyeffects})

    windowrulev2 = center(1),class:(pavucontrol)
    windowrulev2 = float,class:(pavucontrol)
    windowrulev2 = size 40% 60%,class:(pavucontrol})

    windowrulev2 = float, class:^(firefox)$, title:^(Picture-in-Picture)$
    windowrulev2 = move 70% 20%, class:^(firefox)$, title:^(Picture-in-Picture)$
    windowrulev2 = pin,   class:^(firefox)$, title:^(Picture-in-Picture)$

    windowrulev2 = suppressevent maximize, class:.*
  '';
}
