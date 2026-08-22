{inputs, ...}: {
  flake.nixosModules.default = {pkgs, ...}: {
    programs.tmux = {
      enable = true;
      package = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.tmux;
    };
  };
}
