_: {
  perSystem = {pkgs, ...}: {
    treefmt.config = {
      programs = {
        alejandra.enable = true;
        deadnix.enable = true;
        prettier = {
          enable = true;
          package = pkgs.prettier;
        };
        rubocop.enable = true;
        shellcheck.enable = true;
        shfmt.enable = true;
        statix.enable = true;
      };
    };
  };
}
