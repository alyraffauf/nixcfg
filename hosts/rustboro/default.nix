# Lenovo Thinkpad T440p with a Core i5 4210M, 16GB RAM, 512GB SSD.
{
  config,
  lib,
  self,
  ...
}: {
  imports = [
    ./disko.nix
    ./home.nix
    ./secrets.nix
    ./stylix.nix
    self.inputs.nixhw.nixosModules.thinkpad-t440p
    self.nixosModules.common-auto-upgrade
    self.nixosModules.common-base
    self.nixosModules.common-locale
    self.nixosModules.common-mauville-share
    self.nixosModules.common-nix
    self.nixosModules.common-overlays
    self.nixosModules.common-pkgs
    self.nixosModules.common-tailscale
    self.nixosModules.common-wifi-profiles
  ];

  boot = {
    initrd.systemd.enable = true;

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = lib.mkForce false;
    };
  };

  environment.variables.GDK_SCALE = "1.25";
  networking.hostName = "rustboro";
  system.stateVersion = "24.05";
  zramSwap.memoryPercent = 100;

  ar = {
    apps.firefox.enable = true;

    desktop = {
      greetd = {
        enable = true;
        autologin = "aly";
        session = lib.getExe config.programs.sway.package;
      };

      sway.enable = true;
    };

    laptopMode = true;

    users.aly = {
      enable = true;
      password = "$y$j9T$VMCXwk0X5m6xW6FGLc39F/$r9gmyeB70RCq3k4oLPHFZyy7wng6WyX2xYMKLO/A.rB";
      syncthing = {
        enable = true;
        certFile = config.age.secrets.syncthingCert.path;
        keyFile = config.age.secrets.syncthingKey.path;
      };
    };
  };
}
