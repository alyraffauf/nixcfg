_: {
  flake.nixosModules.default = {
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      nssmdns6 = true;

      publish = {
        enable = true;
        userServices = true;
        workstation = true;
      };
    };
  };
}
