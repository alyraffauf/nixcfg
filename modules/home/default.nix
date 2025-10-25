{self, ...}: {
  imports = [
    ./aly
    ./desktop
    ./profiles
    ./programs
    ./services
    self.homeModules.snippets
    self.inputs.cosmic-manager.homeManagerModules.cosmic-manager
    self.inputs.zen-browser.homeModules.beta
  ];
}
