{self, ...}: {
  imports = [self.homeManagerModules.desktop];

  config = {
    dconf = {
      enable = true;

      settings = {
        "org/gnome/desktop/wm/preferences".button-layout = "appmenu:minimize,maximize,close";
      };
    };
  };
}
