{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.users.dustin.enable {
    users.users.dustin = {
      description = "Dustin Raffauf";
      extraGroups = ["networkmanager" "wheel" "docker" "libvirtd" "video"];
      hashedPassword = config.alyraffauf.users.dustin.password;
      isNormalUser = true;
    };
  };
}
