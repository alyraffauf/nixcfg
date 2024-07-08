{
  config,
  inputs,
  lib,
  pkgs,
  self,
  ...
}: {
  config = lib.mkIf config.ar.users.dustin.enable {
    home-manager.users.dustin =
      lib.attrsets.optionalAttrs
      config.ar.users.dustin.manageHome
      (import ../../homes/dustin inputs self);

    users.users.dustin = {
      description = "Dustin Raffauf";
      extraGroups = config.ar.users.defaultGroups;
      hashedPassword = config.ar.users.dustin.password;
      isNormalUser = true;
      uid = 1001;
    };
  };
}
