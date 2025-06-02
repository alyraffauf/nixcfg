{
  lib,
  modulesPath,
  ...
}: {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-gnome.nix"
    ./stylix.nix
  ];

  isoImage.isoBaseName = lib.mkForce "oldale";
  networking.hostName = "oldale";
  nixpkgs.hostPlatform = "x86_64-linux";

  myNixOS = {
    desktop.gnome.enable = true;

    programs = {
      nix.enable = true;
      firefox.enable = true;
    };

    profiles = {
      iso.enable = true;
      workstation.enable = true;
    };
  };

  myUsers.root.enable = true;
}
