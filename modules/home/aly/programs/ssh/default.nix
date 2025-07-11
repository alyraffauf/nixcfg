{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.aly.programs.ssh.enable = lib.mkEnableOption "openssh client";

  config = lib.mkIf config.myHome.aly.programs.ssh.enable {
    programs.ssh = {
      enable = true;
      compression = true;

      matchBlocks = let
        rootMe = name: {
          ${name} = {
            hostname = name;
            user = "root";
          };
        };
      in
        rootMe "dewford"
        // rootMe "evergrande"
        // rootMe "mossdeep"
        // rootMe "slateport"
        // rootMe "verdanturf";

      package = pkgs.openssh;
    };
  };
}
