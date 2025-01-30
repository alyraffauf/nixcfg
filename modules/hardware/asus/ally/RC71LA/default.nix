{
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    self.nixosModules.hardware-amd-cpu
    self.nixosModules.hardware-amd-gpu
    self.nixosModules.hardware-common
  ];

  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.11") (lib.mkDefault pkgs.linuxPackages_latest);

  services = {
    handheld-daemon = {
      enable = lib.mkDefault true;
      ui.enable = lib.mkDefault true;
    };

    power-profiles-daemon.enable = lib.mkDefault true;
    upower.enable = lib.mkDefault true;
  };
}
