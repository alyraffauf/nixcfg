{
  config,
  self,
  ...
}: {
  imports = [
    ./home.nix
    ./secrets.nix
    self.diskoConfigurations.luks-btrfs-subvolumes
    self.nixosModules.locale-en-us
  ];

  boot.initrd.luks.devices."crypted".crypttabExtraOpts = ["fido2-device=auto" "token-timeout=20"];
  environment.variables.GDK_SCALE = "2.0";
  networking.hostName = "pacifidlog";
  nix.daemonCPUSchedPolicy = "idle";
  services.xserver.xkb.options = "ctrl:nocaps";
  system.stateVersion = "25.11";
  time.timeZone = "America/New_York";
  myDisko.installDrive = "/dev/disk/by-id/nvme-SK_hynix_PC801_HFS002TEJ9X101N_BDE4N54161OA05A2VI";
  myHardware.hp.omnibook.fh0xxx.enable = true;

  myNixOS = {
    desktop.gnome.enable = true;

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
      systemd-boot.enable = true;
      nix.enable = true;
      podman.enable = true;
      steam.enable = true;
    };

    services = {
      flatpak.enable = true;
      gdm.enable = true;
      promtail.enable = true;

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
