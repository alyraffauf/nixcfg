{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  home-manager = {
    sharedModules = [
      {
        programs.vscode.userSettings = {
          "editor.fontSize" = lib.mkForce "16";
        };

        home.pointerCursor.size = lib.mkForce 24;

        gtk.font.size = lib.mkForce 14;

        ar.home = {
          services.easyeffects = {
            enable = true;
            preset = "LoudnessEqualizer";
          };
        };
      }
    ];
  };
}
