inputs: {
  config,
  pkgs,
  lib,
  ...
}: let
  unstable = import inputs.nixpkgsUnstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in {
  imports = [
    ./apps
    ./containers
    ./desktop
    ./options.nix
    ./scripts
    ./services
    ./system
    ./users
  ];

  nixpkgs.overlays = [
    (final: prev: {
      audiobookshelf = unstable.audiobookshelf;
      brave = prev.brave.override {commandLineArgs = "--gtk-version=4 --enable-wayland-ime";};
      catppuccin-gtk = prev.catppuccin-gtk.override {
        accents = ["mauve"];
        size = "compact";
        variant = "frappe";
        tweaks = ["normal"];
      };
      catppuccin-kvantum = prev.catppuccin-kvantum.override {
        accent = "Mauve";
        variant = "Frappe";
      };
      catppuccin-papirus-folders = prev.catppuccin-papirus-folders.override {
        flavor = "frappe";
        accent = "mauve";
      };
      catppuccin-plymouth = prev.catppuccin-plymouth.override {variant = "frappe";};
      nerdfonts = prev.nerdfonts.override {fonts = ["Noto"];};
      google-chrome = prev.google-chrome.override {commandLineArgs = "--gtk-version=4 --enable-wayland-ime";};
      hyprland = inputs.hyprland.packages.${pkgs.system}.hyprland;
      hyprnome = unstable.hyprnome;
      hyprshot = unstable.hyprshot;
      xdg-desktop-portal-hyprland = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
      obsidian = unstable.obsidian.overrideAttrs (old: {
        installPhase =
          builtins.replaceStrings ["--ozone-platform=wayland"]
          ["--ozone-platform=wayland --enable-wayland-ime"]
          old.installPhase;
      });
      sway = unstable.sway;
      swayfx = unstable.swayfx;
      vscodium = prev.vscodium.override {commandLineArgs = "--gtk-version=4 --enable-wayland-ime";};
      webcord = prev.webcord.overrideAttrs (old: {
        installPhase =
          builtins.replaceStrings ["--ozone-platform-hint=auto"]
          ["--ozone-platform-hint=auto --enable-wayland-ime"]
          old.installPhase;
      });
    })
  ];
}
