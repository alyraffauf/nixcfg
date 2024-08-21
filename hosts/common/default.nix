{pkgs, ...}: {
  imports = [
    ./locale.nix
    ./network.nix
    ./nix.nix
    ./samba.nix
    ./secrets.nix
  ];

  environment.systemPackages = with pkgs; [git inxi python3];
}
