{
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./backups.nix
    ./home.nix
    ./secrets.nix
    self.inputs.nixos-hardware.nixosModules.raspberry-pi-4
  ];

  environment.systemPackages = [pkgs.rclone];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
      fsType = "ext4";
    };
  };

  hardware.enableRedistributableFirmware = true;

  networking = {
    hostName = "roxanne";
    networkmanager.wifi.powersave = false;
  };

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  services = {
    journald.extraConfig = ''
      # Store logs in RAM
      Compress=yes
      Storage=volatile
      SystemMaxUse=50M
    '';

    tautulli.enable = true;

    uptime-kuma = {
      enable = true;
      appriseSupport = true;
      settings.HOST = "0.0.0.0";
    };
  };

  stylix = {
    enable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/default-dark.yaml";
  };

  system.stateVersion = "25.05";

  systemd.oomd = {
    enable = true;
    enableRootSlice = true;
    enableSystemSlice = true;
    enableUserSlices = true;
  };

  time.timeZone = "America/New_York";

  zramSwap = {
    enable = lib.mkDefault true;
    algorithm = lib.mkDefault "zstd";
    priority = lib.mkDefault 100;
  };

  myNixOS = {
    profiles = {
      autoUpgrade.enable = true;
      base.enable = true;
      media-share.enable = true;
    };

    programs = {
      nix.enable = true;
      podman.enable = true;
    };

    services.tailscale.enable = true;
  };

  myUsers.aly = {
    enable = true;
    password = "$y$j9T$Lit66g43.Zn60mwGig7cx1$L.aLzGvy0q.b1E40/XSIkhj2tkJbigpXFrxR/D/FVB4";
  };
}
