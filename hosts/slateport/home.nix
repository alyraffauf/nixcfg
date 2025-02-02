{
  lib,
  self,
  ...
}: {
  home-manager.users.aly = lib.mkForce (
    {pkgs, ...}: {
      imports = [
        self.homeManagerModules.profiles-shell
        self.homeManagerModules.programs-fastfetch
        self.homeManagerModules.programs-yazi
      ];

      home = {
        homeDirectory = "/home/aly";

        packages = with pkgs; [
          curl
        ];

        stateVersion = "24.05";
        username = "aly";
      };

      programs = {
        helix = {
          enable = true;
          defaultEditor = true;
        };

        home-manager.enable = true;
      };
    }
  );
}
