_: {
  flake.nixosModules.default = {pkgs, ...}: {
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;

      alsa.enable = true;

      pulse.enable = true;

      wireplumber.extraLv2Packages = with pkgs; [
        bankstown-lv2
        lsp-plugins
      ];
    };
  };
}
