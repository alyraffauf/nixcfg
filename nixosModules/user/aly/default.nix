{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.user.aly.enable = lib.mkEnableOption "Enables Aly's user.";
  };

  config = lib.mkIf config.alyraffauf.user.aly.enable {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.aly = {
      isNormalUser = true;
      description = "Aly Raffauf";
      extraGroups = ["networkmanager" "wheel" "docker" "libvirtd" "video"];
    };
  };
}
