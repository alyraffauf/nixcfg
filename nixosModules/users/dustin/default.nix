{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.ar.users.dustin.enable {
    users.users.dustin = {
      description = "Dustin Raffauf";
      extraGroups = ["networkmanager" "wheel" "docker" "libvirtd" "video"];
      hashedPassword = config.ar.users.dustin.password;
      isNormalUser = true;
      uid = 1001;
    };
  };
}
