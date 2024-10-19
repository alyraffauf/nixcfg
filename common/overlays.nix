{self, ...}: {
  nixpkgs = {
    config.allowUnfree = true; # Allow unfree packages

    overlays = [
      self.overlays.rofi-bluetooth
    ];
  };
}
