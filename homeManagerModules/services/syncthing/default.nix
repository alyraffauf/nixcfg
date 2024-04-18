{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.services.syncthing.enable =
      lib.mkEnableOption "Enables syncthing as user.";
  };

  config = lib.mkIf config.alyraffauf.services.syncthing.enable {
    services.syncthing.enable = true;
  };
}
