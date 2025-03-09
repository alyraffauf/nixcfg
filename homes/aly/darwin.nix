{
  lib,
  self,
  ...
}: {
  imports = [
    ./firefox
    ./helix
    ./mail
    ./secrets.nix
    ./vsCode
    self.homeManagerModules.default
    self.inputs.agenix.homeManagerModules.default
  ];

  home = {
    homeDirectory = "/Users/aly";
    stateVersion = "25.05";
    username = "aly";
  };

  programs = {
    home-manager.enable = true;

    vscode.profiles.default.userSettings = {
      "editor.fontFamily" = "CaskaydiaCove Nerd Font";
      "editor.fontSize" = 14;
      "terminal.integrated.fontFamily" = "CaskaydiaCove Nerd Font";
      "terminal.integrated.fontSize" = 14;
      "window.titleBarStyle" = lib.mkForce "custom";
    };
  };

  myHome = {
    profiles.shell.enable = true;
    programs.fastfetch.enable = true;
  };
}
