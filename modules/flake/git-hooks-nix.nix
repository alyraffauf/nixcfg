_: {
  perSystem = {pkgs, ...}: {
    pre-commit.settings.hooks = {
      alejandra.enable = true;
      deadnix.enable = true;
      prettier = {
        enable = true;
        package = pkgs.prettier;
      };
      shellcheck.enable = true;

      shfmt = {
        enable = true;
        args = ["-i" "2"];
      };

      statix.enable = true;
    };
  };
}
