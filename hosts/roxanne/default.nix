{
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./home.nix
    ./secrets.nix
    self.inputs.nixos-hardware.nixosModules.raspberry-pi-4
  ];

  boot.kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_rpi4;
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

  services.journald.extraConfig = ''
    # Store logs in RAM
    Compress=yes
    Storage=volatile
    SystemMaxUse=50M
  '';

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
      data-share.enable = true;
      lowResource.enable = true;
      media-share.enable = true;
    };

    programs = {
      nix.enable = true;
      podman.enable = true;
    };

    services = {
      caddy.enable = true;

      forgejo-runner = {
        enable = true;
        number = 1;
      };

      tailscale.enable = true;
    };
  };

  myUsers.aly.enable = true;
}
