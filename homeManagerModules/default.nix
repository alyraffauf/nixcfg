{ config, pkgs, ... }:

{
  imports = [ ./cliApps ./guiApps ./desktopEnv ./userServices ];

  nixpkgs = {
    # Configure nixpkgs instance
    config = {
      # Enableunfree packages
      allowUnfree = true;
    };
  };
}
