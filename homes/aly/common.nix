{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./firefox
    ./ghostty
    ./git
    ./helix
    ./mail
    ./secrets.nix
    ./vsCode
    self.homeManagerModules.default
    self.inputs.agenix.homeManagerModules.default
  ];

  home = {
    packages = with pkgs; [
      curl
      rclone
      vesktop
    ];

    username = "aly";
  };

  programs = {
    awscli = {
      enable = true;

      credentials = {
        "default" = {
          "credential_process" = ''sh -c "${lib.getExe' pkgs.uutils-coreutils-noprefix "cat"} ${config.age.secrets.aws.path}"'';
        };
      };
    };

    home-manager.enable = true;
  };

  myHome = {
    profiles.shell.enable = true;
    programs.fastfetch.enable = true;
  };
}
