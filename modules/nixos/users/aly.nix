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

    users.users = {
      aly = {
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
        hashedPasswordFile = config.sops.secrets.aly-password.path;
        home = "/home/aly";
        uid = 1000;
      };
    };
  };
}
