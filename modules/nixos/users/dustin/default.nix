{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.myUsers.dustin.enable {
    users.users.dustin = {
      description = "Dustin Raffauf";
      extraGroups = config.myUsers.defaultGroups;
      hashedPassword = config.myUsers.dustin.password;
      isNormalUser = true;
      uid = 1001;
    };
  };
}
