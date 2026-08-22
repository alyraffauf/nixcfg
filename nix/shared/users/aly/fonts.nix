_: let
  fonts = pkgs:
    with pkgs; [
      adwaita-fonts
      nerd-fonts.caskaydia-cove
      nerd-fonts.fira-code
    ];
in {
  flake = {
    nixosModules.aly = {pkgs, ...}: {
      fonts.packages = fonts pkgs;
    };

    homeModules.aly = {pkgs, ...}: {
      home.packages = fonts pkgs;
    };

    darwinModules.aly = {
      homebrew.casks = [
        "font-caskaydia-cove-nerd-font"
        "font-fira-code-nerd-font"
      ];
    };
  };
}
