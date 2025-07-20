{self, ...}: {
  perSystem = {pkgs, ...}: {
    inherit (self.packages.${pkgs.system}) formatter;
  };
}
