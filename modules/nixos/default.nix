{lib, ...}: {
  options.flake.nixosModules.default = lib.mkOption {
    type = lib.types.deferredModule;
    default = {};
  };
}
