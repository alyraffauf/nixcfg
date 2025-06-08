{self, ...}: {
  imports = [
    ./home.nix
    ./secrets.nix
    ./stylix.nix
    self.nixosModules.disko-btrfs-subvolumes
    self.nixosModules.hardware-lenovo-thinkpad-T440p
    self.nixosModules.locale-en-us
  ];

  environment.variables.GDK_SCALE = "1.25";
  networking.hostName = "rustboro";
  nix.settings.max-jobs = 0;
  services.xserver.xkb.options = "ctrl:nocaps";
  system.stateVersion = "25.05";
  time.timeZone = "America/New_York";
  myDisko.installDrive = "/dev/sda";

  myNixOS = {
    desktop.gnome.enable = true;

    profiles = {
      autoUpgrade.enable = true;
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
      gdm.enable = true;
      tailscale.enable = true;
    };
  };

  myUsers.aly = {
    enable = true;
    password = "$y$j9T$VMCXwk0X5m6xW6FGLc39F/$r9gmyeB70RCq3k4oLPHFZyy7wng6WyX2xYMKLO/A.rB";
  };
}
