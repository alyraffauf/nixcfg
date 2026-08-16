_: {
  flake.nixosModules.mauville = {
    services.displayManager.gdm.autoSuspend = false;
  };
}
