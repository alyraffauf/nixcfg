{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.aly.programs.awscli.enable = lib.mkEnableOption "awscli";

  config = lib.mkIf config.myHome.aly.programs.awscli.enable {
    sops.secrets.aws = {
      sopsFile = ../../../../../secrets/aws.yaml;
      key = "credentials";
    };

    programs.awscli = {
      enable = true;

      credentials = {
        "default" = {
          "credential_process" = ''sh -c "${lib.getExe' pkgs.uutils-coreutils-noprefix "cat"} ${config.sops.secrets.aws.path}"'';
        };
      };
    };
  };
}
