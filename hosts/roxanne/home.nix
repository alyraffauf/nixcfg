{
  lib,
  self,
  ...
}: {
  home-manager.users.aly = lib.mkForce (
    {...}: {
      imports = [self.homeManagerModules.default];

      home = {
        homeDirectory = "/home/aly";
        stateVersion = "25.05";
        username = "aly";
      };

      programs = {
        helix = {
          enable = true;
          defaultEditor = true;
        };

        home-manager.enable = true;
      };

      myHome = {
        profiles.shell.enable = true;
        programs.fastfetch.enable = true;
      };
    }
  );
}
