{
  config,
  lib,
  pkgs,
  ...
}: {
  options.ar.users = let
    mkUser = user: {
      enable = lib.mkEnableOption "${user}.";

      manageHome = lib.mkOption {
        description = "Whether to manage ${user}'s home directory.";
        type = lib.types.bool;
        default = true;
      };

      password = lib.mkOption {
        description = "Hashed password for ${user}.";
        type = lib.types.str;
      };
    };
  in {
    defaultGroups = lib.mkOption {
      description = "Default groups for desktop users.";
      default = [
        "dialout"
        "docker"
        "libvirtd"
        "lp"
        "networkmanager"
        "scanner"
        "transmission"
        "video"
        "wheel"
      ];
    };

    aly = mkUser "aly";
    dustin = mkUser "dustin";
    morgan = mkUser "morgan";
  };
}
