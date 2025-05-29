{
  pkgs,
  self,
  ...
}: {
  imports = [self.homeManagerModules.default];

  home = {
    packages = with pkgs; [
      curl
      rclone
      wget
    ];

    username = "aly";
  };

  programs.home-manager.enable = true;
  xdg.enable = true;
  stylix.targets.firefox.profileNames = ["default"];

  myHome = {
    aly = {
      profiles.mail.enable = true;

      programs = {
        awscli.enable = true;
        firefox.enable = true;
        git.enable = true;
        halloy.enable = true;
        helix.enable = true;
        thunderbird.enable = true;
        vesktop.enable = true;
        vsCode.enable = true;
        zen.enable = true;
      };
    };

    profiles.shell.enable = true;

    programs = {
      fastfetch.enable = true;
      ghostty.enable = true;
    };
  };
}
