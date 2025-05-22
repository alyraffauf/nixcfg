{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  options.myNixOS.programs.nix.enable = lib.mkEnableOption "sane nix configuration";

  config = lib.mkIf config.myNixOS.programs.nix.enable {
    nix = {
      buildMachines = lib.mkIf config.services.tailscale.enable (
        lib.filter (m: m.hostName != "${config.networking.hostName}") config.mySnippets.nix.buildMachines
      );

      distributedBuilds = true;

      gc = {
        automatic = true;
        options = "--delete-older-than 5d";
        persistent = true;
        randomizedDelaySec = "60min";
      };

      # Run GC when there is less than 1GiB left.
      extraOptions = ''
        min-free = ${toString (1 * 1024 * 1024 * 1024)}   # 1 GiB
        max-free = ${toString (5 * 1024 * 1024 * 1024)}   # 5 GiB
      '';

      optimise = {
        automatic = true;
        persistent = true;
        randomizedDelaySec = "60min";
      };

      package = pkgs.lix;
      settings = config.mySnippets.nix.settings;
    };

    programs.nix-ld.enable = true;

    users.users.nixbuild = {
      uid = 1999;
      isNormalUser = true;
      createHome = false;
      group = "nixbuild";

      openssh.authorizedKeys.keyFiles =
        lib.map (file: "${self.inputs.secrets}/publicKeys/${file}")
        (lib.filter (file: lib.hasPrefix "aly_" file)
          (builtins.attrNames (builtins.readDir "${self.inputs.secrets}/publicKeys")))
        ++ lib.map (file: "${self.inputs.secrets}/publicKeys/${file}")
        (lib.filter (file: lib.hasPrefix "root_" file)
          (builtins.attrNames (builtins.readDir "${self.inputs.secrets}/publicKeys")));
    };

    users.groups.nixbuild = {};
  };
}
