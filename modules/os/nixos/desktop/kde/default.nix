{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myNixOS.desktop.kde.enable = lib.mkEnableOption "KDE desktop environment";

  config = lib.mkIf config.myNixOS.desktop.kde.enable {
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

    environment.systemPackages = with pkgs; [
      kdePackages.sddm-kcm
      maliit-keyboard
    ];

    home-manager.sharedModules = [
      {
        config.myHome.desktop.kde.enable = true;
      }
    ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org.maliit.keyboard.maliit" = {
            key-press-haptic-feedback = true;
            theme = "BreezeDark";
          };
        };
      }
    ];

    services.desktopManager.plasma6.enable = true;
    myNixOS.desktop.enable = true;
  };
}
