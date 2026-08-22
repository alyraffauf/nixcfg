{inputs, ...}: {
  flake.darwinModules.default = {pkgs, ...}: {
    environment.systemPackages = [
      inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.tmux
    ];
  };
}
