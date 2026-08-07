{
  config,
  lib,
  ...
}: {
  options.myNixOS.services.cachefilesd.enable = lib.mkEnableOption "cachefilesd for nfs and smb caching";

  config = lib.mkIf config.myNixOS.services.cachefilesd.enable {
    services.cachefilesd = {
      enable = true;

      extraConfig = ''
        brun 20%
        bcull 10%
        bstop 5%
      '';
    };
  };
}
