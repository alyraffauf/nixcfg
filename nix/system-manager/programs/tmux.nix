{inputs, ...}: {
  flake.systemModules.default = {pkgs, ...}: {
    environment.systemPackages = [
      inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.tmux
    ];
  };
}
