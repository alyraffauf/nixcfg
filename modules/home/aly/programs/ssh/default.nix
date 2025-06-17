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

      matchBlocks = {
        "mossdeep" = {
          hostname = "mossdeep";
          user = "root";
        };

        "slateport" = {
          hostname = "slateport";
          user = "root";
        };

        "verdanturf" = {
          hostname = "verdanturf";
          user = "root";
        };
      };

      package = pkgs.openssh;
    };
  };
}
