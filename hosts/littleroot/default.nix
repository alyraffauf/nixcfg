{
  lib,
  modulesPath,
  ...
}: {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  isoImage.isoBaseName = lib.mkForce "littleroot";
  networking.hostName = "littleroot";
  nixpkgs.hostPlatform = "x86_64-linux";

  myNixOS = {
    profiles.iso.enable = true;
    programs.nix.enable = true;
  };

  myUsers.root.enable = true;
}
