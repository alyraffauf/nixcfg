# Default overlay.
_: final: prev: {
  ghostty = prev.ghostty.overrideAttrs (_: {
    preBuild = ''
      shopt -s globstar
      sed -i 's/^const xev = @import("xev");$/const xev = @import("xev").Epoll;/' **/*.zig
      shopt -u globstar
    '';
  });

  headphones = prev.headphones.overrideAttrs (old: let
    version = "0.6.4";
  in {
    inherit version;
    src = old.src.override {
      rev = "v${version}";
      sha256 = "0gv7rasjbm4rf9izghibgf5fbjykvzv0ibqc2in1naagjivqrpq4";
    };
  });
}
