{inputs, ...}: {
  flake.systemConfigs.sootopolis = inputs.system-manager.lib.makeSystemConfig {
    modules = [
      inputs.nix-system-graphics.systemModules.default
      ({pkgs, ...}: {
        environment.systemPackages = with pkgs; [
          ghostty
          inputs.system-manager.packages.x86_64-linux.default
          vscode
        ];

        nixpkgs = {
          config.allowUnfree = true;
          hostPlatform = "x86_64-linux";
        };
        system-manager.allowAnyDistro = true;
        system-graphics.enable = true;
      })
    ];
  };
}
