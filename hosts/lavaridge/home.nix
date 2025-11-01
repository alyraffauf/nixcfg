{self, ...}: {
  home-manager.users.aly = {pkgs, ...}: {
    imports = [
      self.homeModules.default
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

      stateVersion = "25.11";
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
      aly.programs = {
        git.enable = true;
        awscli.enable = true;
        rbw.enable = true;
        ssh.enable = true;
      };

      profiles.shell.enable = true;
      programs.fastfetch.enable = true;
    };
  };
}
