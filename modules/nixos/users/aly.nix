_: {
  flake.nixosModules.aly = {
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
    nix.settings.trusted-users = lib.mkAfter ["aly"];

    sops.secrets.aly-password = {
      neededForUsers = true;
      sopsFile = self + "/secrets/aly-password.yaml";
    };

    users = {
      groups.aly = {};

      users.aly = {
        description = "Aly Raffauf";
        extraGroups = [
          "cdrom"
          "dialout"
          "docker"
          "libvirtd"
          "lp"
          "networkmanager"
          "plugdev"
          "scanner"
          "transmission"
          "video"
          "wheel"
        ];
        group = "aly";
        hashedPasswordFile = config.sops.secrets.aly-password.path;
        home = "/home/aly";
        isNormalUser = true;
        openssh.authorizedKeys.keyFiles = alyKeyFiles;
        uid = 1000;
      };
    };
  };
}
