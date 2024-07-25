#!/bin/bash
nix run nixpkgs#update-nix-fetchgit -- homeManagerModules/desktop/default.nix homes/aly/firefox/default.nix homes/aly/mail/default.nix
