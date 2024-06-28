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
        ar.home = {
          services.easyeffects = {
            enable = true;
            preset = "LoudnessEqualizer";
          };
          theme = {
            cursorTheme.size = lib.mkForce 32;
            font.size = lib.mkForce 14;
            terminalFont.size = lib.mkForce 14;
          };
        };
      }
    ];
    users.aly = import ../../homes/aly;
  };
}
