{inputs, ...}: {
  flake.systemModules.default = {
    imports = [inputs.nix-system-graphics.systemModules.default];

    system-graphics.enable = true;
  };
}
