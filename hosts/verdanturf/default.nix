{
  lib,
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    ./secrets.nix
    "${modulesPath}/virtualisation/amazon-image.nix"
  ];

  environment = {
    etc = {
      "fail2ban/filter.d/vaultwarden.conf".text = ''
        [INCLUDES]
        before = common.conf

        [Definition]
        failregex = ^.*Username or password is incorrect\. Try again\. IP: <ADDR>\. Username:.*$
        ignoreregex =
        journalmatch = _SYSTEMD_UNIT=vaultwarden.service
      '';
      "fail2ban/filter.d/vaultwarden-admin.conf".text = ''
        [INCLUDES]
        before = common.conf

        [Definition]
        failregex = ^.*Invalid admin token\. IP: <ADDR>.*$
        ignoreregex =
        journalmatch = _SYSTEMD_UNIT=vaultwarden.service
      '';
    };

    systemPackages = with pkgs; [htop zellij];
  };

  networking.hostName = "verdanturf";
  nixpkgs.hostPlatform = "x86_64-linux";

  services = {
    fail2ban = {
      enable = true;
      bantime = "24h";
      bantime-increment.enable = true;

      jails = {
        vaultwarden = ''
          enabled = true
          filter = vaultwarden
          port = 80,443,8000
          maxretry = 5
        '';

        vaultwarden-admin = ''
          enabled = true
          port = 80,443
          filter = vaultwarden-admin
          maxretry = 3
          bantime = 14400
          findtime = 14400
        '';
      };
    };

    vaultwarden = {
      enable = true;

      config = {
        DOMAIN = "https://passwords.raffauflabs.com";
        ROCKET_ADDRESS = "0.0.0.0";
        ROCKET_LOG = "critical";
        ROCKET_PORT = 8222;
        SIGNUPS_ALLOWED = false;
      };
    };
  };

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

  users.users.root.openssh.authorizedKeys.keyFiles =
    lib.map (file: ../../secrets/publicKeys + "/${file}")
    (lib.filter (file: lib.hasPrefix "aly_" file)
      (builtins.attrNames (builtins.readDir ../../secrets/publicKeys)));

  myNixOS = {
    profiles = {
      autoUpgrade.enable = true;
      server.enable = true;
    };

    programs.nix.enable = true;
    services.tailscale.enable = true;
  };
}
