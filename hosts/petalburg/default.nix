# Asus TUF a16
{
  config,
  self,
  ...
}: {
  imports = [
    ./home.nix
    ./secrets.nix
    ./stylix.nix
    (import ./../../disko/luks-btrfs-subvolumes.nix {disks = ["/dev/nvme0n1"];})
    self.nixosModules.common-locale
    self.nixosModules.common-mauville-share
    self.nixosModules.common-wifi-profiles
    self.nixosModules.hw-asus-tuf-a16-amd-7030
    self.nixosModules.nixos-desktop-kde
    self.nixosModules.nixos-profiles-autoUpgrade
    self.nixosModules.nixos-profiles-base
    self.nixosModules.nixos-profiles-btrfs
    self.nixosModules.nixos-profiles-desktopOptimizations
    self.nixosModules.nixos-profiles-gaming
    self.nixosModules.nixos-profiles-lanzaboote
    self.nixosModules.nixos-programs-firefox
    self.nixosModules.nixos-programs-nix
    self.nixosModules.nixos-programs-steam
    self.nixosModules.nixos-services-sddm
    self.nixosModules.nixos-services-tailscale
  ];

  environment.variables.GDK_SCALE = "1";
  networking.hostName = "petalburg";
  system.stateVersion = "25.05";

  ar.users.aly = {
    enable = true;
    password = "$y$j9T$NSS7QcEtN4yiigPyofwlI/$nxdgz0lpySa0heDMjGlHe1gX3BWf48jK6Tkfg4xMEs6";

    syncthing = {
      enable = true;
      certFile = config.age.secrets.syncthingCert.path;
      keyFile = config.age.secrets.syncthingKey.path;
      syncMusic = true;
      syncROMs = true;
    };
  };
}
