# Default overlay.
{self}: final: prev: {
  rofi-bluetooth = self.packages.${prev.system}.rofi-bluetooth;
}
