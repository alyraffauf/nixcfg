{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  options.myNixOS.profiles.iso.enable = lib.mkEnableOption "base system configuration for iso environments";

  config = lib.mkIf config.myNixOS.profiles.iso.enable {
    boot = {
      kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

      supportedFilesystems = lib.mkForce [
        "btrfs"
        "vfat"
        "f2fs"
        "xfs"
        "ntfs"
        "cifs"
      ];
    };

    documentation.nixos.enable = false;

    environment = {
      etc."nixos".source = self;

      systemPackages = with pkgs; [
        (inxi.override {withRecommends = true;})
        helix
        htop
        lm_sensors
        wget
      ];
    };

    networking = {
      networkmanager.enable = true;
      wireless.enable = lib.mkForce false;
    };

    nix.distributedBuilds = lib.mkForce false;

    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
        silent = true;
      };

      git = {
        enable = true;
        package = pkgs.gitMinimal;
      };

      ssh.knownHosts = config.mySnippets.ssh.knownHosts;
    };

    system = {
      configurationRevision = self.rev or self.dirtyRev or null;
      rebuild.enableNg = true;
      switch.enable = false;
    };
  };
}
