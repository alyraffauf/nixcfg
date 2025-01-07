{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    git
    htop
    (inxi.override {withRecommends = true;})
    python3
  ];
}
