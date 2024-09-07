{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    git
    htop
    inxi
    python3
  ];
}
