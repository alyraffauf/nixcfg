{
  config,
  self,
  ...
}: {
  imports = [
    ./home.nix
    ./secrets.nix
    ./stylix.nix
    self.nixosModules.disko-luks-btrfs-subvolumes
    self.nixosModules.hardware-lenovo-thinkpad-X1-gen-9
    self.nixosModules.locale-en-us
  ];

  environment.variables.GDK_SCALE = "1.25";
  networking.hostName = "sootopolis";
  services.xserver.xkb.options = "ctrl:nocaps";
  system.stateVersion = "25.05";
  time.timeZone = "America/New_York";
  myDisko.installDrive = "/dev/disk/by-id/nvme-SHPP41-1000GM_ANCAN50211160B42I";

  myNixOS = {
    desktop.hyprland = {
      enable = true;
      laptopMonitor = "desc:Chimei Innolux Corporation 0x1417,preferred,auto,1.25";
    };

    profiles = {
      autoUpgrade.enable = true;
      base.enable = true;
      btrfs.enable = true;
      data-share.enable = true;
      media-share.enable = true;
      swap.enable = true;
      wifi.enable = true;
      workstation.enable = true;
    };

    programs = {
      lanzaboote.enable = true;
      nix.enable = true;
      podman.enable = true;
      steam.enable = true;
    };

    services = {
      greetd.enable = true;

      syncthing = {
        enable = true;
        certFile = config.age.secrets.syncthingCert.path;
        keyFile = config.age.secrets.syncthingKey.path;
        syncMusic = false;
        syncROMs = true;
        user = "aly";
      };

      tailscale.enable = true;
    };
  };

  myUsers.aly = {
    enable = true;
    password = "$y$j9T$VMCXwk0X5m6xW6FGLc39F/$r9gmyeB70RCq3k4oLPHFZyy7wng6WyX2xYMKLO/A.rB";
  };
}
