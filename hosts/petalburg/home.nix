{self, ...}: {
  home-manager = {
    sharedModules = [
      {
        ar.home.services = {
          easyeffects = {
            enable = true;
            preset = "AdvancedAutoGain";
          };
        };
      }
    ];

    users.aly = self.homeManagerModules.aly;
  };
}
