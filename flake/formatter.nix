{self, ...}: {
  perSystem = {pkgs, ...}: {
    formatter = self.packages.${pkgs.system}.formatter;
  };
}
