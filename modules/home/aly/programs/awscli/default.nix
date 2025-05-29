{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    self.inputs.agenix.homeManagerModules.default
  ];

  options.myHome.aly.programs.awscli.enable = lib.mkEnableOption "awscli";

  config = lib.mkIf config.myHome.aly.programs.awscli.enable {
    age.secrets.aws.file = "${self.inputs.secrets}/aly/aws.age";

    programs.awscli = {
      enable = true;

      credentials = {
        "default" = {
          "credential_process" = ''sh -c "${lib.getExe' pkgs.uutils-coreutils-noprefix "cat"} ${config.age.secrets.aws.path}"'';
        };
      };
    };
  };
}
