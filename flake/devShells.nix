_: {
  perSystem = {
    config,
    lib,
    pkgs,
    inputs',
    ...
  }: {
    devShells.default = pkgs.mkShell {
      packages =
        (with pkgs; [
          (lib.hiPrio uutils-coreutils-noprefix)
          bash-language-server
          git
          nh
          nixd
        ])
        ++ lib.attrValues config.treefmt.build.programs
        ++ [
          inputs'.agenix.packages.default
          inputs'.disko.packages.disko-install
          inputs'.nynx.packages.nynx
        ];

      shellHook = ''
        ${config.pre-commit.installationScript}
        export FLAKE="." NH_FLAKE="."
      '';
    };
  };
}
