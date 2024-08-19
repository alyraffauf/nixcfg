#!/bin/bash
nix run nixpkgs#update-nix-fetchgit -- homeManagerModules/desktop/default.nix 
nix run nixpkgs#update-nix-fetchgit -- homeManagerModules/desktop/default.nix hosts/fallarbor/stylix.nix hosts/lavaridge/stylix.nix hosts/mauville/stylix.nix hosts/petalburg/stylix.nix hosts/rustboro/stylix.nix
