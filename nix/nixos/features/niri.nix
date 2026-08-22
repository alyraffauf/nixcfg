_: {
  flake.nixosModules.niri = {
    pkgs,
    self,
    ...
  }: {
    environment.systemPackages = [
      pkgs.adwaita-icon-theme
      pkgs.file-roller
      pkgs.ghostty
      pkgs.gnome-disk-utility
      pkgs.gnome-text-editor
      pkgs.loupe
      pkgs.nautilus
      pkgs.xwayland-satellite
    ];

    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.niri-aly;
      useNautilus = true;
    };

    programs.noctalia = {
      enable = true;
      recommendedServices.enable = true;
      systemd.enable = true;
    };

    services.displayManager.noctalia-greeter = {
      enable = true;
      settings.session.default = "Niri";
    };

    services.gvfs.enable = true;

    xdg.icons.fallbackCursorThemes = ["Adwaita"];
  };
}
