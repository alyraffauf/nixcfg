{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.user.dustin = {
      enable = lib.mkEnableOption "Enables Dustin's user.";
      password = lib.mkOption {
        description = "Hashed password.";
        type = lib.types.str;
      };
    };
  };

  config = lib.mkIf config.alyraffauf.user.dustin.enable {
    users.users.dustin = {
      description = "Dustin Raffauf";
      extraGroups = ["networkmanager" "wheel" "docker" "libvirtd" "video"];
      hashedPassword = config.alyraffauf.user.dustin.password;
      isNormalUser = true;
    };
  };
}
