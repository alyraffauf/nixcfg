{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.services.binaryCache.enable = lib.mkEnableOption "Enable nixpkgs cache server.";
  };

  config = lib.mkIf config.alyraffauf.services.binaryCache.enable {
    services.nix-serve = {
      enable = true;
      secretKeyFile = "/var/cache-priv-key.pem";
    };
  };
}
