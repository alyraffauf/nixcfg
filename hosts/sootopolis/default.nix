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

  environment.variables.GDK_SCALE = "1.2";
  networking.hostName = "sootopolis";
  services.xserver.xkb.options = "ctrl:nocaps";
  system.stateVersion = "25.05";
  time.timeZone = "America/New_York";

  myNixOS = {
    desktop = {
      hyprland = {
        enable = true;
        laptopMonitor = "eDP-1,preferred,auto,1.20";
      };
    };

    profiles = {
      autoUpgrade.enable = true;
      base.enable = true;
      btrfs.enable = true;
      desktop.enable = true;
      media-share.enable = true;
      wifi.enable = true;
    };

    programs = {
      firefox.enable = true;
      nix.enable = true;
      lanzaboote.enable = true;
    };

    services = {
      greetd.enable = true;

      syncthing = {
        enable = true;
        certFile = config.age.secrets.syncthingCert.path;
        keyFile = config.age.secrets.syncthingKey.path;
        syncMusic = true;
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
