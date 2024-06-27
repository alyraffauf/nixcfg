{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.ar.services.binaryCache.enable {
    services.nix-serve = {
      enable = true;
      secretKeyFile = "/var/cache-priv-key.pem";
    };
  };
}
