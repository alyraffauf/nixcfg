_: {
  flake = {
    nixosModules.aly = {
      config,
      lib,
      pkgs,
      self,
      ...
    }: {
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
          shell = pkgs.fish;
          uid = 1000;
        };
      };
    };

    darwinModules.aly = {
      users.users.aly = {
        description = "Aly Raffauf";
        home = "/Users/aly";
      };
    };
  };
}
