_: {
  flake.nixosModules.default = {
    programs.system-config-printer.enable = true;
    services.printing.enable = true;
  };
}
