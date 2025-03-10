{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myDarwin.programs.nix.enable = lib.mkEnableOption "sane nix configuration";

  config = lib.mkIf config.myDarwin.programs.nix.enable {
    nix = {
      buildMachines =
        lib.filter (m: m.hostName != "${config.networking.hostName}") (import ../../../nixos/os/programs/nix/buildMachines.nix);

      distributedBuilds = true;

      gc = {
        automatic = true;

        interval = [
          {
            Hour = 9;
          }
        ];
      };

      linux-builder = {
        enable = true;
        ephemeral = true;

        config.virtualisation = {
          cores = 6;

          darwin-builder = {
            diskSize = 40 * 1024;
            memorySize = 8 * 1024;
          };
        };

        maxJobs = 4;
      };

      package = pkgs.lix;

      settings = import ../../../nixos/os/programs/nix/settings.nix;
    };
  };
}
