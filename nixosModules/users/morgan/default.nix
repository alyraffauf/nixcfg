{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.ar.users.morgan.enable {
    users.users.morgan = {
      description = "Morgan Tamayo";
      extraGroups = ["networkmanager" "wheel" "docker" "libvirtd" "video"];
      hashedPassword = config.ar.users.morgan.password;
      isNormalUser = true;
      uid = 1002;
    };
  };
}
