{self, ...}: {
  home-manager = {
    sharedModules = [
      {
        imports = [self.homeManagerModules.services-easyeffects];
        myHome.services.easyeffects.preset = "fw13-easy-effects";
      }
    ];

    users = {
      aly = self.homeManagerModules.aly;
      dustin = self.homeManagerModules.dustin;
    };
  };
}
