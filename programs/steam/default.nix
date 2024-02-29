{ config, pkgs, ... }:

{
  services.flatpak.packages = [
    "com.valvesoftware.Steam"
  ];
  hardware.steam-hardware.enable = true;
}
