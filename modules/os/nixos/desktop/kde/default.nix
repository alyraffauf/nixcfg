{
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [self.nixosModules.nixos-desktop];

  config = {
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
        myHome.desktop.kde.enable = lib.mkDefault true;
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
  };
}
