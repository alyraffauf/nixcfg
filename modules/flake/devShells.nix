_: {
  perSystem = {
    config,
    lib,
    pkgs,
    inputs',
    self',
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
          self'.packages.gen-files
        ];

      shellHook = ''
        echo "Installing pre-commit hooks..."
        ${config.pre-commit.installationScript}
        echo "Generating files..."
        ${lib.getExe self'.packages.gen-files}
        export FLAKE="." NH_FLAKE="."
        echo "👋 Welcome to the nixcfg devShell!"
      '';
    };
  };
}
