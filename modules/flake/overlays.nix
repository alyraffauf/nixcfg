{self, ...}: {
  flake.overlays = {
    default = _final: prev: let
      nixos-unstable-small = import self.inputs.nixpkgs-unstable-small {
        config.allowUnfree = true;
        inherit (prev) system;
      };
    in {
      inherit (nixos-unstable-small) firefox plex plexRaw thunderbird zed-editor;

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
