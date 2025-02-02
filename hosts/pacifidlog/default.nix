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
    self.nixosModules.hardware-asus-ally-RC72LA
    self.nixosModules.locale-en-us
  ];

  environment.variables.GDK_SCALE = "2";
  networking.hostName = "pacifidlog";
  services.xserver.xkb.options = "ctrl:nocaps";
  system.stateVersion = "25.05";
  time.timeZone = "America/New_York";

  myNixOS = {
    desktop.steamos = {
      enable = true;
      user = "aly";
    };

    profiles = {
      autoUpgrade.enable = true;
      base.enable = true;
      btrfs.enable = true;
      desktop.enable = true;
      gaming.enable = true;
      media-share.enable = true;
      wifi.enable = true;
    };

    programs = {
      firefox.enable = true;
      lanzaboote.enable = true;
      nix.enable = true;
      steam.enable = true;
    };

    services = {
      syncthing = {
        enable = true;
        certFile = config.age.secrets.syncthingCert.path;
        keyFile = config.age.secrets.syncthingKey.path;
        syncMusic = false;
        syncROMs = true;
        user = "aly";
      };

      tailscale.enable = true;
    };
  };

  myUsers.aly = {
    enable = true;
    password = "$y$j9T$NSS7QcEtN4yiigPyofwlI/$nxdgz0lpySa0heDMjGlHe1gX3BWf48jK6Tkfg4xMEs6";
  };
}
