_: {
  flake.nixosModules.default = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      bankstown-lv2
      lsp-plugins
    ];
  };
}
