{inputs, ...}: {
  flake.nixosModules.default = {pkgs, ...}: {
    imports = [inputs.nix-flatpak.nixosModules.nix-flatpak];

    services.flatpak = {
      enable = true;

      update.auto = {
        enable = true;
        onCalendar = "weekly";
      };
    };

    xdg.portal = {
      enable = true;
      config.common.default = "*";
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
      xdgOpenUsePortal = true;
    };
  };
}
