{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.users.morgan.enable {
    users.users.morgan = {
      description = "Morgan Tamayo";
      extraGroups = ["networkmanager" "wheel" "docker" "libvirtd" "video"];
      hashedPassword = config.alyraffauf.users.morgan.password;
      isNormalUser = true;
      uid = 1002;
    };
  };
}
