{...}: {
  imports = [./common.nix];

  home = {
    homeDirectory = "/Users/aly";
    shellAliases."docker" = "podman";
  };

  xdg.enable = true;
}
