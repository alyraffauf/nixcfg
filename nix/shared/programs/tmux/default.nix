{inputs, ...}: let
  tmuxPackage = pkgs: inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.tmux;

  programs = {pkgs, ...}: {
    programs.tmux = {
      enable = true;
      package = tmuxPackage pkgs;
    };
  };

  packages = {pkgs, ...}: {
    environment.systemPackages = [
      (tmuxPackage pkgs)
    ];
  };
in {
  flake = {
    nixosModules.default = programs;
    darwinModules.default = packages;
    homeModules.aly = programs;
    systemModules.default = packages;
  };
}
