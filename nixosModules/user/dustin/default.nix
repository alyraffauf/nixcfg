{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.user.dustin.enable = lib.mkEnableOption "Enables Dustin's user.";
    alyraffauf.user.dustin.password = lib.mkOption {
      description = "Hashed password.";
      type = lib.types.str;
    };
  };

  config = lib.mkIf config.alyraffauf.user.dustin.enable {
    users.users.dustin = {
      isNormalUser = true;
      description = "Dustin Raffauf";
      extraGroups = ["networkmanager" "wheel" "docker" "libvirtd" "video"];
      hashedPassword = config.alyraffauf.user.dustin.password;
    };
  };
}
