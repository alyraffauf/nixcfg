{
  config,
  self,
  ...
}: {
  imports = [
    ./home.nix
    ./secrets.nix
    ./stylix.nix
    self.diskoConfigurations.luks-btrfs-subvolumes
    self.nixosModules.locale-en-us
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "sd_mod" "r8169"];
  networking.hostName = "petalburg";
  system.stateVersion = "25.11";
  time.timeZone = "America/New_York";
  myDisko.installDrive = "/dev/nvm0n1";

  myHardware = {
    amd = {
      cpu.enable = true;
      gpu.enable = true;
    };

    profiles.base.enable = true;
  };

  myNixOS = {
    desktop.gnome.enable = true;

    profiles = {
      autoUpgrade.enable = true;
      backups.enable = true;
      base.enable = true;
      btrfs.enable = true;
      swap.enable = true;
      wifi.enable = true;
      workstation.enable = true;
    };

    programs = {
      nix.enable = true;
      podman.enable = true;
      systemd-boot.enable = true;
    };

    services = {
      caddy.enable = true;
      flatpak.enable = true;
      gdm.enable = true;
      prometheusNode.enable = true;
      promtail.enable = true;
      steam.enable = true;

      syncthing = {
        enable = true;
        certFile = config.age.secrets.syncthingCert.path;
        keyFile = config.age.secrets.syncthingKey.path;
        syncMusic = true;
        syncROMs = true;
        user = "aly";
      };

      tailscale = {
        enable = true;
        operator = "aly";
      };
    };
  };

  myUsers.aly = {
    enable = true;
    password = "$y$j9T$.fv9yQ8dHh/oyZ8M.b67h.$sHKoOdzIvltyVNk2zi8F.bUNcwIonjGTtzwYgOcb0H3";
  };
}
