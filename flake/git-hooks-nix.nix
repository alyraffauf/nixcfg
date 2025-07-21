{self, ...}: {
  perSystem = {pkgs, ...}: {
    pre-commit.settings.hooks = {
      alejandra.enable = true;
    };
  };
}
