{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  imports = [./aly ./dustin];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = inputs;
  };

  users.mutableUsers = false;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOuRiyf9Fbl3Plqqzy5YkE2UJv8evF8YI9eG7Iu2CIRa aly@petalburg"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINHdpGTfjmnnau18CowChY4hPn/fzRkgJvXFs+yPy74I aly@mauville"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEREYTfh+b8XKcfTLpENqRzzWQLSkXCZIKGUFTlmJPy6 aly@lavaridge"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOz2Lvy5WB/fCJnbK4eY2MY4CTYkKqQzUwRkXWiipHSc aly@rustboro"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGcJBb7+ZxkDdk06A0csNsbgT9kARUN185M8k3Lq7E/d u0_a336@localhost" # termux on winona
  ];
}
