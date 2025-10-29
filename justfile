# just is a command runner, Justfile is very similar to Makefile, but simpler.

############################################################################
#
#  Common recipes
#
############################################################################

# List all recipes
default:
    @printf '\e[1;36m%s\e[0m\n' "nixcfg — Recipes"; \
    printf '\e[1;33mUsage:\e[0m  just <recipe> [-- args]\n\n'; \
    just --list | sed 's/^/  /'

# Generate {ci,edconfig} files
[group('flake')]
gen target:
    nix run .#{{ if target == "ci" { "render-workflows" } else if target == "edconfig" { "gen-files" } else { error("unknown target: " + target) } }}

# Update flake inputs
[group('flake')]
up *inputs:
    nix flake update {{ inputs }} --commit-lock-file

# Update all nixpkgs inputs
[group('flake')]
upnix: (up "nixpkgs" "nixpkgs-unstable-small")

############################################################################
#
#  NixOS
#
############################################################################

############################################################################
#
#  Darwin
#
############################################################################

# Reset launchpad to force it to reindex Applications
[group('desktop')]
[macos]
reset-launchpad:
    defaults write com.apple.dock ResetLaunchPad -bool true
    killall Dock

############################################################################
#
#  Servers
#
############################################################################

# Deploy hosts with nynx
[group('servers')]
deploy jobs='':
    nynx --operation switch {{ if jobs == "" { "" } else { "--jobs " + jobs } }}
