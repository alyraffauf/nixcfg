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
        "cdrom"
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

    root.enable = lib.mkEnableOption "root user configuration." // {default = true;};
    aly = mkUser "aly";
    dustin = mkUser "dustin";
  };
}
