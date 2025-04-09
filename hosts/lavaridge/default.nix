{self, ...}: {
  imports = [
    ./home.nix
    ./secrets.nix
    ./stylix.nix
    self.nixosModules.disko-luks-btrfs-subvolumes
    self.nixosModules.hardware-framework-13-intel-11th
    self.nixosModules.locale-en-us
  ];

  environment.variables.GDK_SCALE = "1.5";
  networking.hostName = "lavaridge";
  services.xserver.xkb.options = "ctrl:nocaps";
  system.stateVersion = "25.05";
  time.timeZone = "America/New_York";

  myNixOS = {
    desktop.hyprland = {
      enable = true;
      laptopMonitor = "desc:BOE 0x095F,preferred,auto,1.566667";
    };

    profiles = {
      autoUpgrade.enable = true;
      base.enable = true;
      btrfs.enable = true;
      media-share.enable = true;
      workstation.enable = true;
      swap.enable = true;
      wifi.enable = true;
    };

    programs = {
      lanzaboote.enable = true;
      nix.enable = true;
      podman.enable = true;
    };

    services = {
      greetd.enable = true;
      tailscale.enable = true;
    };
  };

  myUsers.aly = {
    enable = true;
    password = "$y$j9T$VMCXwk0X5m6xW6FGLc39F/$r9gmyeB70RCq3k4oLPHFZyy7wng6WyX2xYMKLO/A.rB";
  };
}
