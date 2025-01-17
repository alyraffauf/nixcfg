{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.ar.users.dustin.enable {
    users.users.dustin = {
      description = "Dustin Raffauf";
      extraGroups = config.ar.users.defaultGroups;
      hashedPassword = config.ar.users.dustin.password;
      isNormalUser = true;
      uid = 1001;
    };
  };
}
