{
  config,
  lib,
  ...
}: {
  options.myDarwin.programs.nix.enable = lib.mkEnableOption "sane nix configuration";

  config = lib.mkIf config.myDarwin.programs.nix.enable {
    nix = {
      buildMachines =
        lib.filter (m: m.hostName != "${config.networking.hostName}") config.mySnippets.nix.buildMachines;

      distributedBuilds = true;

      gc = {
        automatic = true;

        interval = [
          {
            Hour = 9;
          }
        ];

        options = "--delete-older-than 7d"; # Free when >20GB space left and when older than 10 days.
      };

      # linux-builder = {
      #   enable = true;
      #   ephemeral = true;

      #   config.virtualisation = {
      #     cores = 6;

      #     darwin-builder = {
      #       diskSize = 40 * 1024;
      #       memorySize = 8 * 1024;
      #     };
      #   };

      #   maxJobs = 4;
      # };

      settings = config.mySnippets.nix.settings;
    };
  };
}
