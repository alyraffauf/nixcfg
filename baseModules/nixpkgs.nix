{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  nixpkgs = let
    unstable = import inputs.nixpkgsUnstable {
      system = pkgs.system;
      config.allowUnfree = true; # Allow unfree packages
    };
  in {
    config.allowUnfree = true; # Allow unfree packages

    # Overlays over default packages.
    overlays = [
      inputs.nur.overlay
      (final: prev: {
        alyraffauf-wallpapers = inputs.wallpapers.packages.${pkgs.system}.default;
        brave = prev.brave.override {commandLineArgs = "--gtk-version=4 --enable-wayland-ime";};
        google-chrome = prev.google-chrome.override {commandLineArgs = "--gtk-version=4 --enable-wayland-ime";};
        hyprland = inputs.hyprland.packages.${pkgs.system}.hyprland;
        nerdfonts = prev.nerdfonts.override {fonts = ["Noto"];};

        obsidian = prev.obsidian.overrideAttrs (old: {
          installPhase =
            builtins.replaceStrings ["--ozone-platform=wayland"]
            ["--ozone-platform=wayland --enable-wayland-ime"]
            old.installPhase;
        });

        vscodium = prev.vscodium.override {commandLineArgs = "--enable-wayland-ime";};

        webcord = prev.webcord.overrideAttrs (old: {
          installPhase =
            builtins.replaceStrings ["--ozone-platform-hint=auto"]
            ["--ozone-platform-hint=auto --enable-wayland-ime"]
            old.installPhase;
        });

        xdg-desktop-portal-hyprland = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
      })
    ];
  };
}
