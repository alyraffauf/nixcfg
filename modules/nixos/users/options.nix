{lib, ...}: {
  options.myUsers = let
    mkUser = user: {
      enable = lib.mkEnableOption "${user}.";

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
        "plugdev"
        "scanner"
        "transmission"
        "video"
        "wheel"
      ];
    };

    aly = mkUser "aly";
    dustin = mkUser "dustin";
  };
}
