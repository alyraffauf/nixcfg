{ pkgs, lib, config, ... }: {

  options = {
    homeLab.binaryCache.enable = lib.mkEnableOption "Enables nixpkgs cache.";
  };

  config = lib.mkIf config.homeLab.binaryCache.enable {
    services.nix-serve = {
      enable = true;
      secretKeyFile = "/var/cache-priv-key.pem";
    };
  };
}
