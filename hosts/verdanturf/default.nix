{
  config,
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

  nix.settings.max-jobs = 0;
  nixpkgs.hostPlatform = "x86_64-linux";
  programs.ssh.knownHosts = config.mySnippets.ssh.knownHosts;

  services = {
    # amazon-cloudwatch-agent.enable = true;
    amazon-ssm-agent.enable = true;
  };

  system = {
    autoUpgrade.operation = "switch";
    stateVersion = "24.11";
  };

  time.timeZone = "America/New_York";

  myNixOS = {
    profiles = {
      autoUpgrade.enable = true;
      backups.enable = true;
      server.enable = true;

      swap = {
        enable = true;
        size = 2048;
      };
    };

    programs.nix.enable = true;

    services = {
      caddy.enable = true;
      prometheusNode.enable = true;
      promtail.enable = true;
      tailscale.enable = true;
    };
  };

  myUsers.root.enable = true;
}
