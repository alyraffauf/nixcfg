# Lenovo Thinkpad T440p with a Core i5 4210M, 16GB RAM, 512GB SSD.
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
    self.nixosModules.hardware-lenovo-thinkpad-T440p
    self.nixosModules.locale-en-us
  ];

  environment.variables.GDK_SCALE = "1.25";
  networking.hostName = "rustboro";
  services.xserver.xkb.options = "ctrl:nocaps";
  system.stateVersion = "24.05";
  time.timeZone = "America/New_York";
  myDisko.installDrive = "/dev/sda";

  myNixOS = {
    desktop = {
      hyprland = {
        enable = true;
        laptopMonitor = "desc:LG Display 0x0569,preferred,auto,1.20";
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
      lanzaboote.enable = true;
      nix.enable = true;
    };

    services = {
      greetd = {
        enable = true;
        # autologin = "aly";
        # session = lib.getExe config.programs.hyprland.package;
      };

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

  myUsers = {
    aly = {
      enable = true;
      password = "$y$j9T$VMCXwk0X5m6xW6FGLc39F/$r9gmyeB70RCq3k4oLPHFZyy7wng6WyX2xYMKLO/A.rB";
    };

    dustin = {
      enable = true;
      password = "$y$j9T$Dj0ydy3mkzZApRRMy5Af.1$tvYnEZWgvdAVExGOuLoLXGDBUueEPosgcBDnJzak1R9";
    };
  };
}
