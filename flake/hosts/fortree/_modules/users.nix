{
  lib,
  self,
  ...
}: let
  keysDirectory = self + "/keys";
  alyKeyFiles = lib.map (file: "${keysDirectory}/${file}") (
    lib.filter (file: lib.hasPrefix "aly_" file)
      (builtins.attrNames (builtins.readDir keysDirectory))
  );
in {
  users.users = {
    aly = {
      description = "Aly Raffauf";
      home = "/Users/aly";
      openssh.authorizedKeys.keyFiles = alyKeyFiles;
    };

    root.openssh.authorizedKeys.keyFiles = alyKeyFiles;
  };
}
