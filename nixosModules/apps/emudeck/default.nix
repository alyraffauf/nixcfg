{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf (config.ar.apps.emudeck.enable) {
    environment.systemPackages = with pkgs; [emudeck];

    ar = {
      apps.steam.enable = lib.mkDefault true;
      services.flatpak.enable = lib.mkDefault true;
    };
  };
}
