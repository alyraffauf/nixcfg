{inputs, ...}: {
  flake.nixosModules.aly = {
    imports = [inputs.helium-browser.nixosModules.default];

    programs.helium.enable = true;
  };
}
