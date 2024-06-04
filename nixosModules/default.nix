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
    ./scripts
    ./services
    ./system
    ./user
  ];

  nixpkgs.overlays = [
    (final: prev: {
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
      obsidian = unstable.obsidian.overrideAttrs (old: {
        installPhase = ''
          runHook preInstall
          mkdir -p $out/bin
          makeWrapper ${pkgs.electron}/bin/electron $out/bin/obsidian \
            --add-flags $out/share/obsidian/app.asar \
            --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-wayland-ime}}"
          install -m 444 -D resources/app.asar $out/share/obsidian/app.asar
          install -m 444 -D resources/obsidian.asar $out/share/obsidian/obsidian.asar
          install -m 444 -D "${old.desktopItem}/share/applications/"* \
            -t $out/share/applications/
          for size in 16 24 32 48 64 128 256 512; do
            mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
            convert -background none -resize "$size"x"$size" ${old.icon} $out/share/icons/hicolor/"$size"x"$size"/apps/obsidian.png
          done
          runHook postInstall
        '';
      });
      sway = unstable.sway;
      swayfx = unstable.swayfx;
      vscodium = prev.vscodium.override {commandLineArgs = "--gtk-version=4 --enable-wayland-ime";};
      webcord = prev.webcord.overrideAttrs (old: {
        installPhase = let
          binPath = lib.makeBinPath [pkgs.xdg-utils];
        in ''
          runHook preInstall

          # Remove dev deps that aren't necessary for running the app
          npm prune --omit=dev

          mkdir -p $out/lib/node_modules/webcord
          cp -r app node_modules sources package.json $out/lib/node_modules/webcord/

          install -Dm644 sources/assets/icons/app.png $out/share/icons/hicolor/256x256/apps/webcord.png

          # Add xdg-utils to path via suffix, per PR #181171
          makeWrapper '${lib.getExe pkgs.electron}' $out/bin/webcord \
            --suffix PATH : "${binPath}" \
            --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime}}" \
            --add-flags $out/lib/node_modules/webcord/

          runHook postInstall
        '';
      });
    })
  ];
}
