_: {
  flake.darwinModules.default = {
    lib,
    self,
    ...
  }: let
    keysDirectory = self + "/keys";
    alyKeyFiles = lib.pipe (builtins.readDir keysDirectory) [
      builtins.attrNames
      (lib.filter (file: lib.hasPrefix "aly_" file))
      (lib.map (file: "${keysDirectory}/${file}"))
    ];
  in {
    users.users = {
      aly.openssh.authorizedKeys.keyFiles = alyKeyFiles;
      root.openssh.authorizedKeys.keyFiles = alyKeyFiles;
    };
  };
}
