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

  networking = {
    firewall.allowedTCPPorts = [80 443];
    hostName = "verdanturf";
  };

  nix.gc.options = lib.mkForce "--delete-older-than 2d";
  nixpkgs.hostPlatform = "x86_64-linux";

  swapDevices = [
    {
      device = "/swap";
      size = 1024;
    }
  ];

  system = {
    autoUpgrade.operation = "switch";
    stateVersion = "24.11";
  };

  time.timeZone = "America/New_York";

  users.users.root.openssh.authorizedKeys.keyFiles =
    lib.map (file: "${self.inputs.secrets}/publicKeys/${file}")
    (lib.filter (file: lib.hasPrefix "aly_" file)
      (builtins.attrNames (builtins.readDir "${self.inputs.secrets}/publicKeys")));

  myNixOS = {
    profiles = {
      autoUpgrade.enable = true;
      server.enable = true;
    };

    programs.nix.enable = true;
    services.tailscale.enable = true;
  };
}
