{pkgs, ...}: {
  imports = [./gui.nix];

  # environment.plasma6.excludePackages = lib.attrsets.attrValues {
  #   inherit
  #     (pkgs.kdePackages)
  #     elisa
  #     gwenview
  #     krdp
  #     okular
  #     oxygen
  #     ;
  # };

  environment.systemPackages = [pkgs.kdePackages.sddm-kcm];
  services.desktopManager.plasma6.enable = true;
}
