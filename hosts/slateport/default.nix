{
  config,
  self,
  ...
}: {
  imports = [
    ./home.nix
    ./raffauflabs.nix
    ./secrets.nix
    self.nixosModules.common-mauville-share
    self.nixosModules.common-wifi-profiles
    self.nixosModules.disko-btrfs-subvolumes
    self.nixosModules.hw-lenovo-thinkcentre-m700
    self.nixosModules.locale-en-us
    self.nixosModules.nixos-profiles-autoUpgrade
    self.nixosModules.nixos-profiles-base
    self.nixosModules.nixos-profiles-btrfs
    self.nixosModules.nixos-profiles-serverOptimizations
    self.nixosModules.nixos-programs-nix
    self.nixosModules.nixos-programs-podman
    self.nixosModules.nixos-services-syncthing
    self.nixosModules.nixos-services-tailscale
  ];

  networking.hostName = "slateport";
  nixos.installDrive = "/dev/sda";
  services.syncthing.guiAddress = "0.0.0.0:8384";

  stylix = {
    enable = false;
    image = "${self.inputs.wallpapers}/wallhaven-mp886k.jpg";
  };

  system = {
    autoUpgrade.operation = "switch";
    stateVersion = "24.05";
  };

  myNixOS.syncthing = {
    enable = true;
    certFile = config.age.secrets.syncthingCert.path;
    keyFile = config.age.secrets.syncthingKey.path;
    user = "aly";
  };

  myUsers.aly = {
    enable = true;
    password = "$y$j9T$Lit66g43.Zn60mwGig7cx1$L.aLzGvy0q.b1E40/XSIkhj2tkJbigpXFrxR/D/FVB4";
  };
}
