{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.users.morgan.enable {
    home-manager.users.morgan =
      if config.ar.users.morgan.manageHome
      then import ../../../homes/morgan
      else {};

    users.users.morgan = {
      description = "Morgan Tamayo";
      extraGroups = ["networkmanager" "wheel" "docker" "libvirtd" "video"];
      hashedPassword = config.ar.users.morgan.password;

      isNormalUser = true;
      uid = 1002;
    };
  };
}
