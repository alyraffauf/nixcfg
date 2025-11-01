{self, ...}: {
  imports = [
    ./aly
    ./desktop
    ./profiles
    ./programs
    ./services
    self.inputs.cosmic-manager.homeManagerModules.cosmic-manager
    self.inputs.snippets.homeModules.snippets
    self.inputs.zen-browser.homeModules.beta
  ];
}
