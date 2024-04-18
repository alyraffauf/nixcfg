{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.homeLab.binaryCache.enable = lib.mkEnableOption "Enables nixpkgs cache.";
  };

  config = lib.mkIf config.alyraffauf.homeLab.binaryCache.enable {
    services.nix-serve = {
      enable = true;
      secretKeyFile = "/var/cache-priv-key.pem";
    };
  };
}
