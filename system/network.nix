{ config, pkgs, ... }:

{
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking = {
    wireless.iwd.enable = true;
    networkmanager.enable = true;
    networkmanager.wifi.backend = "iwd";
    
    firewall.allowedTCPPortRanges = [
      # KDE Connect
      { from = 1714; to = 1764; }
      # Soulseek
      { from = 2234; to = 2239; }
    ];
    firewall.allowedUDPPortRanges = [
      # KDE/GS Connect
      { from = 1714; to = 1764; }
      # Soulseek
      { from = 2234; to = 2239; }
    ];
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services = {
    # Enable avahi for auto network discovery.
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        addresses = true;
        enable = true;
        workstation = true;
      };
    };
    # Enable remote connections with SSH.
    openssh = {
      enable = true;
      openFirewall = true;
    };
    # Enable printing.
    printing.enable = true;
    # Syncthing runs as a user service, but needs its ports open here.
    syncthing.openDefaultPorts = true;
    # Enable tailscale for easy Wireguard VPNs on a tailnet.
    tailscale.enable = true;
  };
}
