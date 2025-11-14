{
  config,
  lib,
  self,
  ...
}: let
  isBuildMachine = let buildHosts = lib.map (m: m.hostName) config.mySnippets.nix.buildMachines; in lib.elem config.networking.hostName buildHosts;
in {
  options.myNixOS.programs.nix.enable = lib.mkEnableOption "sane nix configuration";

  config = lib.mkIf config.myNixOS.programs.nix.enable {
    nix = {
      buildMachines = lib.mkIf config.services.tailscale.enable (
        lib.filter (m: m.hostName != config.networking.hostName)
        config.mySnippets.nix.buildMachines
      );

      channel.enable = false;
      distributedBuilds = true;

      gc = {
        automatic = true;

        options =
          if isBuildMachine
          then "--delete-older-than 20d"
          else "--delete-older-than 3d";

        persistent = true;
        randomizedDelaySec = "60min";
      };

      extraOptions = ''
        min-free = ${toString (1 * 1024 * 1024 * 1024)}   # 1 GiB
        max-free = ${toString (5 * 1024 * 1024 * 1024)}   # 5 GiB
      '';

      optimise = {
        automatic = true;
        persistent = true;
        randomizedDelaySec = "60min";
      };

      inherit (config.mySnippets.nix) settings;
    };

    programs.nix-ld.enable = true;

    # Only create the nixbuild user (and its group) on build machines
    users.users.nixbuild = lib.mkIf isBuildMachine {
      uid = 1999;
      isNormalUser = true;
      createHome = false;
      group = "nixbuild";

      openssh.authorizedKeys.keyFiles = let
        pubDir = "${self.inputs.secrets}/publicKeys";
        aly = lib.filter (file: lib.hasPrefix "aly_" file) (builtins.attrNames (builtins.readDir pubDir));
        root = lib.filter (file: lib.hasPrefix "root_" file) (builtins.attrNames (builtins.readDir pubDir));
      in
        lib.map (file: "${pubDir}/${file}") (aly ++ root);
    };

    users.groups.nixbuild = lib.mkIf isBuildMachine {};

    myNixOS.programs.njust.recipes.nix = ''
      # Garbage collect Nix store
      [group('nix')]
      gc-nix days="3":
          @echo "Cleaning up Nix generations older than {{days}} days..."
          sudo nix-collect-garbage --delete-older-than {{days}}d

      # Optimize Nix store
      [group('nix')]
      optimize-nix:
          @echo "Optimizing Nix store..."
          sudo nix-store --optimise

      # Free space from Nix store
      [group('nix')]
      cleanup-nix: gc-nix && optimize-nix

      # Repair Nix store
      [group('nix')]
      repair-nix:
          sudo nix-store --repair --verify --check-contents
    '';
  };
}
