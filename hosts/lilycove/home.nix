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
        abcde
        curl
        ffmpeg-full
        flac
        handbrake
        makemkv
        mediainfo
        mkvtoolnix
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

      zed-editor.installRemoteServer = true;
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
