{ config, pkgs, ... }:

{
  services.flatpak.packages = [
    "com.valvesoftware.Steam"
  ];
  hardware.steam-hardware.enable = true;
  # programs.steam = {
  #   enable = true;
  #   remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  #   dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  # };
}
