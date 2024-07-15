{
  defaultWorkspaces = [1 2 3 4 5 6 7 8 9];

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
