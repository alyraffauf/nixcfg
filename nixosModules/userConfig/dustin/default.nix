{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    userConfig.dustin.enable = lib.mkEnableOption "Enables Dustin's user.";
  };

  config = lib.mkIf config.userConfig.dustin.enable {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.dustin = {
      isNormalUser = true;
      description = "Dustin Raffauf";
      extraGroups = ["networkmanager" "wheel" "docker" "libvirtd" "video"];
    };
  };
}
