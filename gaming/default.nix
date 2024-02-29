{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
#   environment.systemPackages = with pkgs; [
#   ];

  # users.users.aly.packages = with pkgs; [
  #   #heroic
  #  # openrct2
  #   ];
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
}
