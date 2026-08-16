_: {
  flake.nixosModules.aly = {pkgs, ...}: {
    fonts.packages = with pkgs; [
      adwaita-fonts
      nerd-fonts.caskaydia-cove
      nerd-fonts.fira-code
    ];
  };
}
