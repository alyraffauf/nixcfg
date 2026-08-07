_: {
  flake.nixosModules.default = {
    users.users = {
      aly = {
        description = "Aly Raffauf";
        home = "/home/aly";
      };
    };
  };
}
