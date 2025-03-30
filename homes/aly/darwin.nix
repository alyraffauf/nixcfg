{lib, ...}: {
  imports = [./common.nix];

  home = {
    homeDirectory = "/Users/aly";
    shellAliases."docker" = "podman";
  };

  programs.vscode.profiles.default.userSettings = {
    "window.titleBarStyle" = lib.mkForce "custom";
  };

  xdg.enable = true;
}
