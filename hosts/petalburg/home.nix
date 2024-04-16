{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  users.users.aly.hashedPassword = "$y$j9T$Ug0ZLHQQuRciFJDgOI6r00$eHc.KyQY0oU4k0LKRiZiGWJ19jkKNWHpOoyCJbtJif8";
  home-manager.users.aly = {
    imports = [../../homeManagerModules];
    home.username = "aly";
    home.homeDirectory = "/home/aly";

    home.stateVersion = "23.11";
    programs.home-manager.enable = true;
  };
}
