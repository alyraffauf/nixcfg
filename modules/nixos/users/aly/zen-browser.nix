{inputs, ...}: {
  flake.nixosModules.aly = {pkgs, ...}: {
    users.users.aly.packages = [
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
