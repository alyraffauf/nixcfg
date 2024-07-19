{
  config,
  lib,
  self,
  ...
}: {
  config = lib.mkIf config.ar.users.dustin.enable {
    home-manager.users.dustin = self.homeManagerModules.dustin;

    users.users.dustin = {
      description = "Dustin Raffauf";
      extraGroups = config.ar.users.defaultGroups;
      hashedPassword = config.ar.users.dustin.password;
      isNormalUser = true;
      uid = 1001;
    };
  };
}
