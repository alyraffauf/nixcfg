{
  config,
  lib,
  self,
  ...
}: {
  config = lib.mkIf config.myUsers.aly.enable {
    users.users.aly = {
      description = "Aly Raffauf";
      extraGroups = config.myUsers.defaultGroups;
      hashedPassword = config.myUsers.aly.password;
      isNormalUser = true;

      openssh.authorizedKeys.keyFiles =
        lib.map (file: "${self}/keys/${file}")
        (lib.filter (file: lib.hasPrefix "aly_" file)
          (builtins.attrNames (builtins.readDir "${self}/keys")));

      uid = 1000;
    };
  };
}
