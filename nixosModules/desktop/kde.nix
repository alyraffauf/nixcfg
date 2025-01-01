{
  lib,
  pkgs,
  ...
}: {
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

  home-manager.sharedModules = [
    {
      ar.home.desktop.kde.enable = lib.mkDefault true;
    }
  ];

  services.desktopManager.plasma6.enable = true;
}
