{ pkgs, lib, config, ... }: {

  options = {
    userServices.syncthing.enable =
      lib.mkEnableOption "Enables syncthing as user.";
  };

  config = lib.mkIf config.userServices.syncthing.enable {
    services.syncthing.enable = true;
  };
}
