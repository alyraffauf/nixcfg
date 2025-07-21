{self, ...}: {
  home-manager.users = {
    inherit (self.homeConfigurations) aly;
    inherit (self.homeConfigurations) dustin;
  };
}
