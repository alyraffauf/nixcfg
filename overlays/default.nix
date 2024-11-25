# Default overlay.
{self}: final: prev: {
  adjustor = self.packages.${prev.system}.adjustor;
  hhd-ui = self.packages.${prev.system}.hhd-ui;
  emudeck = self.packages.${prev.system}.emudeck;
  rofi-bluetooth = self.packages.${prev.system}.rofi-bluetooth;
}
