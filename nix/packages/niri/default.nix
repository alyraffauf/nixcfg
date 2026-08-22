{
  inputs,
  lib,
  ...
}: {
  perSystem = {pkgs, ...}: {
    packages = lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
      niri-aly = inputs.nix-wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;

        "config.kdl".content = builtins.readFile ./config.kdl;

        prefixVar = [
          [
            "PATH"
            ":"
            (lib.makeBinPath [
              pkgs.brightnessctl
              pkgs.playerctl
              pkgs.wireplumber
            ])
          ]
        ];
      };
    };
  };
}
