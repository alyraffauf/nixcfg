{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.ar.containers.nixos.audiobookshelf.enable {
    containers.audiobookshelf = {
      autoStart = true;
      bindMounts."/Media" = {
        hostPath = config.ar.containers.nixos.audiobookshelf.mediaDirectory;
        isReadOnly = false;
      };
      config = let
        port = config.ar.containers.nixos.audiobookshelf.port;
      in
        {
          config,
          lib,
          pkgs,
          ...
        }: {
          system.stateVersion = "24.05";
          services.audiobookshelf = {
            enable = true;
            openFirewall = true;
            host = "0.0.0.0";
            port = port;
          };
        };
    };
  };
}
