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
    self.nixosModules.disko-luks-btrfs-subvolumes
    self.nixosModules.hardware-lenovo-thinkpad-X1-gen-9
    self.nixosModules.locale-en-us
    self.nixosModules.nixos-desktop-hyprland
    self.nixosModules.nixos-profiles-autoUpgrade
    self.nixosModules.nixos-profiles-base
    self.nixosModules.nixos-profiles-btrfs
    self.nixosModules.nixos-profiles-desktop
    self.nixosModules.nixos-profiles-media-share
    self.nixosModules.nixos-profiles-wifi
    self.nixosModules.nixos-programs-firefox
    self.nixosModules.nixos-programs-lanzaboote
    self.nixosModules.nixos-programs-nix
    self.nixosModules.nixos-services-greetd
    self.nixosModules.nixos-services-syncthing
    self.nixosModules.nixos-services-tailscale
  ];

  environment.variables.GDK_SCALE = "1.2";

  greetd = {
    autologin = "aly";
    session = lib.getExe config.programs.hyprland.package;
  };

  networking.hostName = "sootopolis";
  services.xserver.xkb.options = "ctrl:nocaps";
  system.stateVersion = "25.05";
  time.timeZone = "America/New_York";

  myNixOS.syncthing = {
    enable = true;
    certFile = config.age.secrets.syncthingCert.path;
    keyFile = config.age.secrets.syncthingKey.path;
    syncMusic = true;
    user = "aly";
  };

  myUsers.aly = {
    enable = true;
    password = "$y$j9T$VMCXwk0X5m6xW6FGLc39F/$r9gmyeB70RCq3k4oLPHFZyy7wng6WyX2xYMKLO/A.rB";
  };
}
