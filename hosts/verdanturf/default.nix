{
  config,
  modulesPath,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./anubis.nix
    ./backups.nix
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

  nixpkgs.hostPlatform = "x86_64-linux";
  programs.ssh.knownHosts = config.mySnippets.ssh.knownHosts;

  services = {
    # amazon-cloudwatch-agent.enable = true;
    amazon-ssm-agent.enable = true;
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 2048;
    }
  ];

  system = {
    autoUpgrade.operation = "switch";
    stateVersion = "24.11";
  };

  time.timeZone = "America/New_York";

  myNixOS = {
    profiles = {
      autoUpgrade.enable = true;
      backups.enable = true;
      lowResource.enable = true;
    };

    programs.nix.enable = true;
    services.tailscale.enable = true;
  };

  myUsers.root.enable = true;
}
