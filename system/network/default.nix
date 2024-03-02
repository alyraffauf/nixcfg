{ config, pkgs, ... }:

{
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable tailscale
  services.tailscale.enable = true;

  # Enable avahi.
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.avahi.publish.enable = true;
  services.avahi.publish.addresses = true;
  services.avahi.publish.workstation = true;

  # for a WiFi printer
  services.avahi.openFirewall = true;

  hardware.bluetooth.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open TXP ports for SSH and Syncthing.
  networking.firewall.allowedTCPPorts = [ 22 8384 22000 ];
  
  # Open UDP ports for Syncthing.
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];

  # Open ports for KDE Connect.
  networking.firewall.allowedTCPPortRanges = [
    # KDE Connect
    { from = 1714; to = 1764; }
  ];
  networking.firewall.allowedUDPPortRanges = [
    # KDE Connect
    { from = 1714; to = 1764; }
  ];
}