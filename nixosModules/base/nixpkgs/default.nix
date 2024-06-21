{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.alyraffauf.base.enable {
    nixpkgs = let
      unstable = import inputs.nixpkgsUnstable {
        system = pkgs.system;
        config.allowUnfree = true; # Allow unfree packages
      };
    in {
      config.allowUnfree = true; # Allow unfree packages

      # Overlays over default packages.
      overlays = [
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
          google-chrome = prev.google-chrome.override {commandLineArgs = "--gtk-version=4 --enable-wayland-ime";};
          hyprland = inputs.hyprland.packages.${pkgs.system}.hyprland;
          hyprnome = unstable.hyprnome;
          hyprshot = unstable.hyprshot;
          intel-vaapi-driver = prev.intel-vaapi-driver.override {enableHybridCodec = true;};
          nerdfonts = prev.nerdfonts.override {fonts = ["DroidSansMono" "Noto"];};
          obsidian = prev.obsidian.overrideAttrs (old: {
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
          xdg-desktop-portal-hyprland = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
        })
      ];
    };
  };
}
