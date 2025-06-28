{self, ...}: {
  imports = [
    ./aly
    ./desktop
    ./profiles
    ./programs
    ./services
    self.inputs.zen-browser.homeModules.twilight
  ];
}
