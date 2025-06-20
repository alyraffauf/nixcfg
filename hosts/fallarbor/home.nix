{self, ...}: {
  home-manager.users = {
    inherit (self.homeManagerModules) aly dustin;
  };
}
