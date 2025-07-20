{self, ...}: {
  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShell {
      packages =
        (with pkgs; [
          (lib.hiPrio uutils-coreutils-noprefix)
          alejandra
          bash-language-server
          deadnix
          git
          nh
          nix-update
          nixd
          nodePackages.prettier
          rubocop
          shellcheck
          shfmt
          statix
        ])
        ++ [
          self.inputs.agenix.packages.${pkgs.system}.default
          self.inputs.disko.packages.${pkgs.system}.disko-install
          self.inputs.nynx.packages.${pkgs.system}.nynx
          self.packages.${pkgs.system}.default
        ];

      shellHook = ''
        export FLAKE="." NH_FLAKE="."
      '';
    };
  };
}
