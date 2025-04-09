{self, ...}: {
  home-manager.users.aly = (
    {pkgs, ...}: {
      imports = [
        self.homeManagerModules.default
        self.inputs.agenix.homeManagerModules.default
      ];

      age.secrets.rclone-b2.file = "${self.inputs.secrets}/rclone/b2.age";

      home = {
        homeDirectory = "/home/aly";

        packages = with pkgs; [
          curl
          rclone
          restic
        ];

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
