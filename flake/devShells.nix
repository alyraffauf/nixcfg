{self, ...}: {
  perSystem = {
    config,
    lib,
    pkgs,
    ...
  }: {
    devShells.default = pkgs.mkShell {
      packages =
        (with pkgs; [
          (lib.hiPrio uutils-coreutils-noprefix)
          bash-language-server
          git
          nh
          nix-update
          nixd
          shellcheck
        ])
        ++ lib.attrValues config.treefmt.build.programs
        ++ [
          self.inputs.agenix.packages.${pkgs.system}.default
          self.inputs.disko.packages.${pkgs.system}.disko-install
          self.inputs.nynx.packages.${pkgs.system}.nynx
          self.packages.${pkgs.system}.default
        ];

      shellHook = ''
        ${config.pre-commit.installationScript}
        export FLAKE="." NH_FLAKE="."
      '';
    };
  };
}
