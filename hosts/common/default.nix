{pkgs, ...}: {
  imports = [
    ./locale.nix
    ./network.nix
    ./nix.nix
    ./pipewireFix.nix
    ./samba.nix
    ./secrets.nix
  ];

  environment.systemPackages = with pkgs; [git inxi];
}
