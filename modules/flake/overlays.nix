{self, ...}: {
  flake.overlays = {
    default = _final: prev: let
      nixpkgs-unstable = import self.inputs.nixpkgs-unstable {
        config.allowUnfree = true;
        inherit (prev) system;
      };

      nixos-unstable-small = import self.inputs.nixos-unstable-small {
        config.allowUnfree = true;
        inherit (prev) system;
      };
    in {
      inherit (nixpkgs-unstable) helix ghostty vscode zed-editor;
      inherit (nixos-unstable-small) plex plexRaw;

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
