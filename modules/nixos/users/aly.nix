_: {
  flake.nixosModules.default = {
    users.users = {
      aly = {
        description = "Aly Raffauf";
        home = "/home/aly";
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
      };
    };
  };
}
