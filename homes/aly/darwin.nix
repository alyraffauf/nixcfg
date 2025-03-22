{
  lib,
  self,
  ...
}: {
  imports = [
    ./firefox
    ./ghostty
    ./git
    ./helix
    ./mail
    ./secrets.nix
    ./vsCode
    self.homeManagerModules.default
    self.inputs.agenix.homeManagerModules.default
  ];

  home = {
    homeDirectory = "/Users/aly";
    username = "aly";
  };

  programs = {
    home-manager.enable = true;

    vscode.profiles.default.userSettings = {
      "window.titleBarStyle" = lib.mkForce "custom";
    };
  };

  xdg.enable = true;

  myHome = {
    profiles.shell.enable = true;
    programs.fastfetch.enable = true;
  };
}
