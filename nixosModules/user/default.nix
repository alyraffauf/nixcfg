{
  pkgs,
  lib,
  config,
  inputs,
  unstable,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./aly
    ./dustin
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = {inherit inputs unstable;};
  home-manager.sharedModules = [{imports = [../../homeManagerModules];}];
  home-manager.backupFileExtension = "backup";

  users.mutableUsers = false;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJBK+QkM3C98BxnJtcEOuxjT7bbUG8gsUafrzW9uKuxz aly@petalburg"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINHdpGTfjmnnau18CowChY4hPn/fzRkgJvXFs+yPy74I aly@mauville"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA5xWjZIdMQaQE7vyPP7VRAKNHbrFeh0QtF3bAXni66V aly@lavaridge"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMLAo1qjO7vDiaNzo17haSFERSqMPELHufCfCNhOb9lM aly@rustboro"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGcJBb7+ZxkDdk06A0csNsbgT9kARUN185M8k3Lq7E/d u0_a336@localhost" # termux on winona
  ];
}
