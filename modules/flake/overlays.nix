_: {
  flake.overlays = {
    default = _final: prev: {
      qbittorrent-nox = prev.qbittorrent-nox.overrideAttrs (_old: rec {
        version = "5.1.2";

        src = prev.fetchFromGitHub {
          owner = "qbittorrent";
          repo = "qBittorrent";
          rev = "release-${version}";
          hash = "sha256-2hcG2rMwo5wxVQjCEXXqPLGpdT6ihqtt3HsNlK1D9CA=";
        };
      });
    };
  };
}
