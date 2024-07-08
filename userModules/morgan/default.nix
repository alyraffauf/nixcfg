{
  config,
  inputs,
  lib,
  pkgs,
  self,
  ...
}: {
  config = lib.mkIf config.ar.users.morgan.enable {
    home-manager.users.morgan =
      lib.attrsets.optionalAttrs
      config.ar.users.morgan.manageHome
      (import ../../homes/morgan inputs self);

    users.users.morgan = {
      description = "Morgan Tamayo";
      extraGroups = config.ar.users.defaultGroups;
      hashedPassword = config.ar.users.morgan.password;
      isNormalUser = true;
      uid = 1002;
    };
  };
}
