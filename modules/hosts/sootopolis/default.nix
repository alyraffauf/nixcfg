{inputs, ...}: {
  flake.systemConfigs.sootopolis = inputs.system-manager.lib.makeSystemConfig {
    modules = [
      inputs.nix-system-graphics.systemModules.default
      {
        environment.systemPackages = [
          inputs.system-manager.packages.x86_64-linux.default
        ];
        nixpkgs.hostPlatform = "x86_64-linux";
        system-manager.allowAnyDistro = true;
        system-graphics.enable = true;
      }
    ];
  };
}
