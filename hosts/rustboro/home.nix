{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  home-manager = {
    sharedModules = [
      {
        programs.vscode.userSettings = {
          "editor.fontSize" = "16";
        };
        alyraffauf.services.easyeffects = {
          enable = true;
          preset = "LoudnessEqualizer";
        };
        alyraffauf.desktop.theme = {
          cursorTheme = lib.mkForce {
            name = "Catppuccin-Latte-Dark-Cursors";
            size = 32;
            package = pkgs.catppuccin-cursors.latteDark;
          };
          font = lib.mkForce {
            name = "NotoSans Nerd Font";
            size = 14;
            package = pkgs.nerdfonts.override {fonts = ["Noto"];};
          };
          terminalFont = lib.mkForce {
            name = "NotoSansM Nerd Font";
            size = 14;
            package = pkgs.nerdfonts.override {fonts = ["Noto"];};
          };
        };
      }
    ];
    users.aly = import ../../aly.nix;
  };
}
