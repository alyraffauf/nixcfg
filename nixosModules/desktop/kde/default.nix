{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.desktop.kde.enable {
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
  };
}
