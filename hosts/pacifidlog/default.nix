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
    self.nixosModules.hardware-asus-ally-RC71LA
    self.nixosModules.locale-en-us
    self.nixosModules.nixos-desktop-steamos
    self.nixosModules.nixos-profiles-autoUpgrade
    self.nixosModules.nixos-profiles-base
    self.nixosModules.nixos-profiles-btrfs
    self.nixosModules.nixos-profiles-desktop
    self.nixosModules.nixos-profiles-gaming
    self.nixosModules.nixos-profiles-media-share
    self.nixosModules.nixos-profiles-wifi
    self.nixosModules.nixos-programs-firefox
    self.nixosModules.nixos-programs-lanzaboote
    self.nixosModules.nixos-programs-nix
    self.nixosModules.nixos-programs-steam
    self.nixosModules.nixos-services-syncthing
    self.nixosModules.nixos-services-tailscale
  ];

  environment.variables.GDK_SCALE = "2";
  networking.hostName = "pacifidlog";

  services.xserver.xkb.options = "ctrl:nocaps";
  system.stateVersion = "25.05";
  time.timeZone = "America/New_York";

  myNixOS = {
    steamos.user = "aly";

    syncthing = {
      enable = true;
      certFile = config.age.secrets.syncthingCert.path;
      keyFile = config.age.secrets.syncthingKey.path;
      syncMusic = false;
      syncROMs = true;
      user = "aly";
    };
  };

  myUsers.aly = {
    enable = true;
    password = "$y$j9T$NSS7QcEtN4yiigPyofwlI/$nxdgz0lpySa0heDMjGlHe1gX3BWf48jK6Tkfg4xMEs6";
  };
}
