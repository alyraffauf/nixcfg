{lib, ...}: {
  home-manager.sharedModules = [
    {
      gtk.font.size = lib.mkForce 14;
      home.pointerCursor.size = lib.mkForce 24;
      programs.vscode.userSettings."editor.fontSize" = lib.mkForce "16";

      ar.home = {
        desktop.hyprland.laptopMonitors = ["desc:LG Display 0x0569,preferred,auto,1.0"];

        services.easyeffects = {
          enable = true;
          preset = "LoudnessEqualizer";
        };
      };
    }
  ];
}
