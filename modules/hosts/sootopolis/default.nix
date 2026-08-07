{
  inputs,
  lib,
  ...
}: {
  flake.systemConfigs.sootopolis = inputs.system-manager.lib.makeSystemConfig {
    modules = [
      inputs.nix-system-graphics.systemModules.default
      ({pkgs, ...}: {
        environment.etc."environment.d/10-system-manager.conf".text = lib.mkForce ''
          PATH=/run/system-manager/sw/bin:/usr/local/bin:/usr/bin
          XDG_DATA_DIRS=/run/system-manager/sw/share:/usr/local/share:/usr/share
        '';

        environment.systemPackages = with pkgs; [
          ghostty
          opencode-desktop
          system-manager
          vscode
          zed-editor
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
