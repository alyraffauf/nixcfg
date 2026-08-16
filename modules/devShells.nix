_: {
  perSystem = {
    inputs',
    pkgs,
    ...
  }: {
    devShells.default = pkgs.mkShell {
      packages = [
        inputs'.blzrd.packages.blzrd
        pkgs.git
        pkgs.just
        pkgs.nh
        pkgs.sops
        pkgs.ssh-to-age
      ];

      shellHook = ''
        export FLAKE="." NH_FLAKE="."
        echo "👋 Welcome to the hoenn devShell!"
      '';
    };
  };
}
