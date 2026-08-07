_: {
  flake.nixosModules.default = {
    config,
    self,
    ...
  }: {
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
        uid = 1000;
      };
    };
  };
}
