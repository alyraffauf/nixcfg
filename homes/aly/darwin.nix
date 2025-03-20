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
    home-manager.enable = true;

    vscode.profiles.default.userSettings = {
      "window.titleBarStyle" = lib.mkForce "custom";
    };
  };

  xdg = {
    enable = true;

    configFile."ghostty/config".text = ''
      background-opacity = ${toString config.stylix.opacity.terminal}
      font-family = ${config.stylix.fonts.monospace.name}
      font-size = ${toString (config.stylix.fonts.sizes.terminal + 4)}
      theme = catppuccin-macchiato
    '';
  };

  myHome = {
    profiles.shell.enable = true;
    programs.fastfetch.enable = true;
  };
}
