{self, ...}: {
  home-manager.users = {
    inherit (self.homeModules) aly dustin;
  };
}
