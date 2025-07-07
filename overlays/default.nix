# Default overlay.
_: _final: prev: {
  ghostty = prev.ghostty.overrideAttrs (_: {
    preBuild = ''
      shopt -s globstar
      sed -i 's/^const xev = @import("xev");$/const xev = @import("xev").Epoll;/' **/*.zig
      shopt -u globstar
    '';
  });

  qbittorrent-nox = prev.qbittorrent-nox.overrideAttrs (_old: rec {
    version = "5.1.2";

    src = prev.fetchFromGitHub {
      owner = "qbittorrent";
      repo = "qBittorrent";
      rev = "release-${version}";
      hash = "sha256-2hcG2rMwo5wxVQjCEXXqPLGpdT6ihqtt3HsNlK1D9CA=";
    };
  });
}
