{pkgs, ...}: {
  imports = [
    ./locale.nix
    ./nix.nix
    ./samba.nix
    ./secrets.nix
    ./network.nix
  ];

  environment.systemPackages = with pkgs; [inxi];
}
