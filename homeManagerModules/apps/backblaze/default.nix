{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.ar.home.apps.backblaze.enable {
    home.packages = with pkgs; [backblaze-b2];
  };
}
