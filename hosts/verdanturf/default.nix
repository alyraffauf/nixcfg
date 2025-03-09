{
  lib,
  modulesPath,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./proxy.nix
    ./secrets.nix
    ./services.nix
    ./stylix.nix
    "${modulesPath}/virtualisation/amazon-image.nix"
    self.nixosModules.locale-en-us
  ];

  environment.systemPackages = with pkgs; [
    htop
    rclone
    zellij
  ];

  fileSystems."/storage" = {
    device = "/dev/sdb";
    fsType = "ext4";
  };

  networking = {
    firewall.allowedTCPPorts = [80 443];
    hostName = "verdanturf";
  };

  nix.gc.options = lib.mkForce "--delete-older-than 2d";
  nixpkgs.hostPlatform = "x86_64-linux";

  swapDevices = [
    {
      device = "/storage/swapfile";
      size = 1540;
    }
  ];

  system = {
    autoUpgrade.operation = "switch";
    stateVersion = "24.11";
  };

  time.timeZone = "America/New_York";

  users.users.aly.uid = lib.mkForce 1001;

  myNixOS = {
    profiles = {
      autoUpgrade.enable = true;
      server.enable = true;
    };

    programs.nix.enable = true;
    services.tailscale.enable = true;
  };

  myUsers.aly = {
    enable = true;
    password = "$y$j9T$Lit66g43.Zn60mwGig7cx1$L.aLzGvy0q.b1E40/XSIkhj2tkJbigpXFrxR/D/FVB4";
  };
}
