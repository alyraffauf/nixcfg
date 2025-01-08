# Lenovo Thinkpad T440p with a Core i5 4210M, 16GB RAM, 512GB SSD.
{
  config,
  lib,
  self,
  ...
}: {
  imports = [
    ./home.nix
    ./secrets.nix
    ./stylix.nix
    (import ./../../disko/luks-btrfs-subvolumes.nix {disks = ["/dev/sda"];})
    self.nixosModules.common-locale
    self.nixosModules.common-mauville-share
    self.nixosModules.common-tailscale
    self.nixosModules.common-wifi-profiles
    self.nixosModules.hw-thinkpad-t440p
    self.nixosModules.nixos-desktop-hyprland
    self.nixosModules.nixos-profiles-autoUpgrade
    self.nixosModules.nixos-profiles-base
    self.nixosModules.nixos-profiles-btrfs
    self.nixosModules.nixos-profiles-desktopOptimizations
    self.nixosModules.nixos-profiles-lanzaboote
    self.nixosModules.nixos-programs-firefox
    self.nixosModules.nixos-programs-nix
    self.nixosModules.nixos-services-greetd
  ];

  environment.variables.GDK_SCALE = "1.25";

  greetd = {
    autologin = "aly";
    session = lib.getExe config.programs.hyprland.package;
  };

  networking.hostName = "rustboro";
  system.stateVersion = "24.05";

  ar.users.aly = {
    enable = true;
    password = "$y$j9T$VMCXwk0X5m6xW6FGLc39F/$r9gmyeB70RCq3k4oLPHFZyy7wng6WyX2xYMKLO/A.rB";
    syncthing = {
      enable = true;
      certFile = config.age.secrets.syncthingCert.path;
      keyFile = config.age.secrets.syncthingKey.path;
      syncMusic = true;
    };
  };
}
