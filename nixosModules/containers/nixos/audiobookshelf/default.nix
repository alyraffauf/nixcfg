{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.containers.nixos.audiobookshelf = {
      enable =
        lib.mkEnableOption "Enable audiobookshelf nixos container.";
      mediaDirectory = lib.mkOption {
        description = "Media directory for Audiobookshelf.";
        default = "/mnt/Media";
        type = lib.types.str;
      };
      port = lib.mkOption {
        description = "Port for audiobookshelf.";
        default = 13378;
        type = lib.types.int;
      };
    };
  };

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
