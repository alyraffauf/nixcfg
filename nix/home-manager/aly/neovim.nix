_: {
  flake.homeModules.aly = {
    pkgs,
    self,
    ...
  }: {
    home.packages = [
      self.packages.${pkgs.system}.nvim-astronvim
    ];
  };
}
