{
  lib,
  modulesPath,
  ...
}: {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-gnome.nix"
  ];

  boot.loader.timeout = lib.mkForce 10;
  image.baseName = lib.mkForce "littleroot";
  networking.hostName = "littleroot";
  nixpkgs.hostPlatform = "x86_64-linux";

  myNixOS = {
    desktop.gnome.enable = true;
    programs.firefox.enable = true;
    profiles.iso.enable = true;
    programs.nix.enable = true;
  };

  myUsers.root.enable = true;
}
