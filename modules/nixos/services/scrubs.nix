_: {
  flake.nixosModules.default = {
    services.btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
      fileSystems = ["/"];
    };
  };
}
