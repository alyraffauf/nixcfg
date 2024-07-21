#1/bin/bash
nix run nixpkgs#update-nix-fetchgit -- homeManagerModules/desktop/default.nix
nix run nixpkgs#update-nix-fetchgit -- homes/aly/firefox/default.nix
nix run nixpkgs#update-nix-fetchgit -- homes/aly/mail/default.nix
