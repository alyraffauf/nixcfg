{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.users.morgan.enable {
    home-manager.users.morgan =
      lib.attrsets.optionalAttrs
      config.ar.users.morgan.manageHome
      (import ../../../homes/morgan);

    users.users.morgan = {
      description = "Morgan Tamayo";
      extraGroups = config.ar.users.defaultGroups;
      hashedPassword = config.ar.users.morgan.password;
      isNormalUser = true;
      uid = 1002;
    };
  };
}
