{
  lib,
  self,
  ...
}: {
  home-manager.users.aly = lib.mkForce (
    {pkgs, ...}: {
      imports = [self.homeManagerModules.default];

      home = {
        homeDirectory = "/home/aly";

        packages = with pkgs; [
          curl
        ];

        stateVersion = "24.05";
        username = "aly";
      };

      programs = {
        helix.defaultEditor = true;
        home-manager.enable = true;
      };

      myHome.apps = {
        fastfetch.enable = true;
        helix.enable = true;
        shell.enable = true;
        yazi.enable = true;
      };
    }
  );
}
