_: let
  alyKeyFiles = lib: self: let
    keysDirectory = self + "/keys";
  in
    lib.pipe (builtins.readDir keysDirectory) [
      builtins.attrNames
      (lib.filter (file: lib.hasPrefix "aly_" file))
      (lib.map (file: "${keysDirectory}/${file}"))
    ];
  module = {
    lib,
    self,
    ...
  }: {
    users.users.aly.openssh.authorizedKeys.keyFiles = alyKeyFiles lib self;
  };
in {
  flake = {
    nixosModules.aly = module;
    darwinModules.aly = module;
  };
}
