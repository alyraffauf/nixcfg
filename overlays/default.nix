# Default overlay.
{self, ...}: final: prev: {
  adjustor = self.packages.${prev.system}.adjustor;
}
