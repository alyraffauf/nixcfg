{self, ...}: {
  flake.nynxDeployments = {
    dewford.output = self.nixosConfigurations.dewford.config.system.build.toplevel;
    dewford.user = "root";

    evergrande.output = self.nixosConfigurations.evergrande.config.system.build.toplevel;
    evergrande.user = "root";

    lavaridge.output = self.nixosConfigurations.lavaridge.config.system.build.toplevel;
    lavaridge.user = "root";

    lilycove.output = self.nixosConfigurations.lilycove.config.system.build.toplevel;
    lilycove.user = "root";

    mauville.output = self.nixosConfigurations.mauville.config.system.build.toplevel;
    mauville.user = "root";

    mossdeep.output = self.nixosConfigurations.mossdeep.config.system.build.toplevel;
    mossdeep.user = "root";

    slateport.output = self.nixosConfigurations.slateport.config.system.build.toplevel;
    slateport.user = "root";

    verdanturf.output = self.nixosConfigurations.verdanturf.config.system.build.toplevel;
    verdanturf.user = "root";
  };
}
