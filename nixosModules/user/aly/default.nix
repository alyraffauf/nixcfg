{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.user.aly.enable = lib.mkEnableOption "Enables Aly's user.";
    alyraffauf.user.aly.password = lib.mkOption {
      description = "Hashed password for user aly.";
      type = lib.types.str;
    };
  };

  config = lib.mkIf config.alyraffauf.user.aly.enable {
    users.users.aly = {
      description = "Aly Raffauf";
      extraGroups = ["networkmanager" "wheel" "docker" "libvirtd" "video"];
      hashedPassword = config.alyraffauf.user.aly.password;
      isNormalUser = true;
      openssh.authorizedKeys.keys = config.users.users.root.openssh.authorizedKeys.keys;
    };
  };
}
