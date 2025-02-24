{self, ...}: {
  home-manager.users.aly = (
    {pkgs, ...}: {
      imports = [
        ../../homes/aly/vsCode
        self.homeManagerModules.default
      ];

      home = {
        homeDirectory = "/home/aly";

        packages = with pkgs; [
          curl
          signal-desktop
        ];

        stateVersion = "25.05";
        username = "aly";
      };

      programs = {
        git = {
          enable = true;
          lfs.enable = true;
          userName = "Aly Raffauf";
          userEmail = "aly@raffauflabs.com";

          extraConfig = {
            color.ui = true;
            github.user = "alyraffauf";
            push.autoSetupRemote = true;
          };
        };

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
