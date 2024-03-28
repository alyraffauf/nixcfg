{ inputs, pkgs, lib, config, ... }: {

  options = {
    userConfig.aly.enable = lib.mkEnableOption "Enables Aly's user.";
  };

  config = lib.mkIf config.userConfig.aly.enable {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.aly = {
      isNormalUser = true;
      description = "Aly Raffauf";
      extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" "video" ];
    };
  };
}
