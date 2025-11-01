# just is a command runner, Justfile is very similar to Makefile, but simpler.
############################################################################
#
#  Common recipes
#
############################################################################

# List all recipes
_default:
    @printf '\033[1;36mnixcfg recipes\033[0m\n\n'
    @printf '\033[1;33mUsage:\033[0m just <recipe> [args...]\n\n'
    @just --list --list-heading $'Available recipes:\n\n'

# Generate {ci,edconfig} files
[group('flake')]
gen target:
    nix run .#{{ if target == "ci" { "render-workflows" } else if target == "edconfig" { "gen-files" } else { error("unknown target: " + target) } }}

# Update flake inputs
[group('flake')]
update *inputs:
    nix flake update {{ inputs }} --commit-lock-file

# Update all nixpkgs inputs
[group('flake')]
update-nixpkgs: (update "nixpkgs" "nixpkgs-unstable-small")

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