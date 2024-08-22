{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  domain = "raffauflabs.com";
in {
  imports = [
    ./disko.nix
    ./home.nix
    ./secrets.nix
    ./stylix.nix
    self.inputs.nixhw.nixosModules.common-intel-cpu
    self.inputs.nixhw.nixosModules.common-intel-gpu
    self.inputs.nixhw.nixosModules.common-bluetooth
    self.inputs.nixhw.nixosModules.common-ssd
    self.inputs.raffauflabs.nixosModules.raffauflabs
    self.nixosModules.common-auto-upgrade
    self.nixosModules.common-base
    self.nixosModules.common-mauville-share
    self.nixosModules.common-nix
    self.nixosModules.common-overlays
    self.nixosModules.common-pkgs
    self.nixosModules.common-tailscale
    self.nixosModules.common-wifi-profiles
  ];

  boot = {
    initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "sd_mod"];

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

  hardware.enableAllFirmware = true;
  networking.hostName = "slateport";

  services.k3s = {
    enable = true;
    clusterInit = true;
    role = "server";
    tokenFile = config.age.secrets.k3s.path;
  };

  system.stateVersion = "24.05";
  zramSwap.memoryPercent = 100;

  ar = {
    apps.podman.enable = true;

    users.aly = {
      enable = true;
      password = "$y$j9T$Lit66g43.Zn60mwGig7cx1$L.aLzGvy0q.b1E40/XSIkhj2tkJbigpXFrxR/D/FVB4";

      syncthing = {
        enable = true;
        certFile = config.age.secrets.syncthingCert.path;
        keyFile = config.age.secrets.syncthingKey.path;
        syncMusic = false;
      };
    };
  };

  raffauflabs = {
    inherit domain;
    enable = true;

    services.ddclient = {
      enable = true;
      passwordFile = config.age.secrets.cloudflare.path;
      protocol = "cloudflare";
    };
  };
}
