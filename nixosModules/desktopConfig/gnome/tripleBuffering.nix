{ pkgs, lib, config, ... }: {

  options = {
    desktopConfig.gnome.tripleBuffering.enable =
      lib.mkEnableOption "Enables dynamic triple buffering for GNOME.";
  };

  config = lib.mkIf config.desktopConfig.gnome.tripleBuffering.enable {
    nixpkgs.overlays = [
      (final: prev: {
        gnome = prev.gnome.overrideScope (gnomeFinal: gnomePrev: {
          mutter = gnomePrev.mutter.overrideAttrs (old: {
            src = pkgs.fetchgit {
              url = "https://gitlab.gnome.org/vanvugt/mutter.git";
              # GNOME 45: triple-buffering-v4-45
              rev = "0b896518b2028d9c4d6ea44806d093fd33793689";
              sha256 = "sha256-mzNy5GPlB2qkI2KEAErJQzO//uo8yO0kPQUwvGDwR4w=";
            };
          });
        });
      })
    ];
  };
}
