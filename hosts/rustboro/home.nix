{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  home-manager = {
    sharedModules = [
      {
        programs.vscode.userSettings = {
          "editor.fontSize" = "16";
        };
        alyraffauf = {
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
    users.aly = import ../../homes/aly.nix;
  };
}
