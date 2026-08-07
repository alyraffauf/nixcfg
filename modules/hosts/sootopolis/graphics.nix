{inputs, ...}: {
  flake.systemModules.sootopolis = {
    imports = [inputs.nix-system-graphics.systemModules.default];

    system-graphics.enable = true;
  };
}
