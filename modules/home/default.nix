{self, ...}: {
  imports = [
    ./aly
    ./desktop
    ./profiles
    ./programs
    ./services
    self.homeManagerModules.snippets
    self.inputs.zen-browser.homeModules.twilight
  ];
}
