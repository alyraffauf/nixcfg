{
  config,
  lib,
  self,
  ...
}: {
  imports = [
    ./firefox
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
    stateVersion = "25.05";
    username = "aly";
  };

  programs = {
    ghostty = {
      enable = true;
      package = null;
      settings.font-size = lib.mkForce (toString (config.stylix.fonts.sizes.terminal + 4));
    };

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
