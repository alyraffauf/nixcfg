{self, ...}: {
  home-manager.users = {
    inherit (self.homeManagerModules) aly;
    inherit (self.homeManagerModules) dustin;
  };
}
