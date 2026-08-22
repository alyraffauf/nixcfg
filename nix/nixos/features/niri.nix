_: {
  flake.nixosModules.niri = {
    pkgs,
    self,
    ...
  }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.niri-aly;
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
  };
}
