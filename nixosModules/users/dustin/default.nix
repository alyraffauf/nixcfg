{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.users.dustin.enable {
    home-manager.users.dustin =
      if config.ar.users.dustin.manageHome
      then import ../../../homes/dustin
      else {};

    users.users.dustin = {
      description = "Dustin Raffauf";
      extraGroups = ["networkmanager" "wheel" "docker" "libvirtd" "video"];
      hashedPassword = config.ar.users.dustin.password;

      isNormalUser = true;
      uid = 1001;
    };
  };
}
