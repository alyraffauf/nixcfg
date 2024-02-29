{ config, pkgs, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  system.autoUpgrade.enable = false;
  system.autoUpgrade.allowReboot = false;

  # Delete generations older than 2 days.
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };

  # Automatically optimize the Nix store in the background.
  nix.settings.auto-optimise-store = true;

  # Run GC when there is less than 100MiB left.
  nix.extraOptions = ''
    min-free = ${toString (100 * 1024 * 1024)}
    max-free = ${toString (1024 * 1024 * 1024)}
  '';

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
