{self, ...}: {
  imports = [
    # ./home.nix
    ./secrets.nix
    self.diskoConfigurations.luks-btrfs-subvolumes
    self.nixosModules.locale-en-us
  ];

  networking.hostName = "rustboro";
  nix.daemonCPUSchedPolicy = "idle";
  services.xserver.xkb.options = "ctrl:nocaps";
  system.stateVersion = "26.05";
  time.timeZone = "America/New_York";
  myDisko.installDrive = "/dev/disk/by-id/nvme-SAMSUNG_MZVL8512HELU-00BH1_S79SNX4XA30638";
  myHardware.lenovo.thinkpad.X1.gen-7.enable = true;

  myNixOS = {
    base.enable = true;
    desktop.cosmic.enable = true;

    profiles = {
      btrfs.enable = true;
      data-share.enable = true;

      homebrew = {
        enable = true;
        user = "aly";
      };

      media-share.enable = true;
      wifi.enable = true;
    };

    programs = {
      lanzaboote.enable = true;
      nix.enable = true;
      podman.enable = true;
    };

    services = {
      cosmic-greeter.enable = true;
      flatpak.enable = true;
      tailscale.enable = true;
    };
  };

  myUsers.aly = {
    enable = true;
    password = "$y$j9T$.fv9yQ8dHh/oyZ8M.b67h.$sHKoOdzIvltyVNk2zi8F.bUNcwIonjGTtzwYgOcb0H3";
  };
}
