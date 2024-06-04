inputs: {
  config,
  pkgs,
  lib,
  ...
}: {
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
