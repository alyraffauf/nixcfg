{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.containers.nixos.audiobookshelf.enable {
    containers.audiobookshelf = {
      autoStart = true;
      bindMounts."/Media" = {
        hostPath = config.alyraffauf.containers.nixos.audiobookshelf.mediaDirectory;
        isReadOnly = false;
      };
      config = let
        port = config.alyraffauf.containers.nixos.audiobookshelf.port;
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
