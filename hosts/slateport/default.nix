{
  config,
  self,
  ...
}: {
  imports = [
    ./home.nix
    ./raffauflabs.nix
    ./secrets.nix
    (import ./../../disko/btrfs-subvolumes.nix {disks = ["/dev/sda"];})
    self.nixosModules.common-auto-upgrade
    self.nixosModules.common-base
    self.nixosModules.common-locale
    self.nixosModules.common-mauville-share
    self.nixosModules.common-nix
    self.nixosModules.common-pkgs
    self.nixosModules.common-tailscale
    self.nixosModules.common-wifi-profiles
    self.nixosModules.hw-common
    self.nixosModules.hw-common-bluetooth
    self.nixosModules.hw-common-intel-cpu
    self.nixosModules.hw-common-intel-gpu
    self.nixosModules.hw-common-ssd
    self.nixosModules.nixos-programs-podman
  ];

  boot = {
    initrd.availableKernelModules = ["xhci_pci" "ahci" "sd_mod"];

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

  networking.hostName = "slateport";

  services = {
    fwupd.enable = true;
    syncthing.guiAddress = "0.0.0.0:8384";
  };

  stylix = {
    enable = false;
    image = "${self.inputs.wallpapers}/wallhaven-mp886k.jpg";
  };

  system.stateVersion = "24.05";

  ar.users.aly = {
    enable = true;
    password = "$y$j9T$Lit66g43.Zn60mwGig7cx1$L.aLzGvy0q.b1E40/XSIkhj2tkJbigpXFrxR/D/FVB4";

    syncthing = {
      enable = true;
      certFile = config.age.secrets.syncthingCert.path;
      keyFile = config.age.secrets.syncthingKey.path;
    };
  };
}
