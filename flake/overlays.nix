{self, ...}: {
  flake.overlays = {
    default = import ../overlays/default.nix {inherit self;};
  };
}
