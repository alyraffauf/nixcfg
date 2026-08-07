_: {
  flake.darwinModules.default = {
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
      aly.openssh.authorizedKeys.keyFiles = alyKeyFiles;
      root.openssh.authorizedKeys.keyFiles = alyKeyFiles;
    };
  };
}
