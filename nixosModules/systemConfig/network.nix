{
  config,
  pkgs,
  ...
}: {
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking = {
    networkmanager.enable = true;

    firewall.allowedTCPPortRanges = [
      # Soulseek
      {
        from = 2234;
        to = 2239;
      }
    ];
    firewall.allowedUDPPortRanges = [
      # Soulseek
      {
        from = 2234;
        to = 2239;
      }
    ];
  };

  services = {
    # Enable avahi for auto network discovery.
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        addresses = true;
        userServices = true;
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
