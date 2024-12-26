# Default overlay.
{self}: final: prev: {
  ghostty = self.inputs.ghostty.packages.x86_64-linux.default;
  rofi-bluetooth = self.packages.${prev.system}.rofi-bluetooth;
}
