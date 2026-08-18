_: {
  flake.nixosModules.default = {pkgs, ...}: {
    services.pipewire.wireplumber.extraLv2Packages = with pkgs; [
      bankstown-lv2
      lsp-plugins
    ];
  };
}
