{inputs, ...}: {
  flake.homeModules.aly = {pkgs, ...}: {
    programs.tmux = {
      enable = true;
      package = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.tmux;
    };
  };
}
