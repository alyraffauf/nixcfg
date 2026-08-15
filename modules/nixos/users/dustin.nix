_: {
  flake.nixosModules.dustin = {
    config,
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
    sops.secrets.dustin-password = {
      neededForUsers = true;
      sopsFile = self + "/secrets/dustin-password.yaml";
    };

    users.users.dustin = {
      description = "Dustin Raffauf";
      extraGroups = [
        "cdrom"
        "dialout"
        "lp"
        "networkmanager"
        "plugdev"
        "video"
        "wheel"
      ];
      hashedPasswordFile = config.sops.secrets.dustin-password.path;
      home = "/home/dustin";
      isNormalUser = true;
      openssh.authorizedKeys.keyFiles = alyKeyFiles;
      uid = 1001;
    };
  };
}
