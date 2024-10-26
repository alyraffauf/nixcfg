{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.desktop.kde.enable {
    environment.plasma6.excludePackages = lib.attrsets.attrValues {
      inherit
        (pkgs.kdePackages)
        elisa
        gwenview
        krdp
        okular
        oxygen
        ;
    };

    services.desktopManager.plasma6.enable = true;
  };
}
