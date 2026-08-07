_: {
  flake.nixosModules.default = {pkgs, ...}: {
    programs.appimage = {
      enable = true;
      binfmt = true;
      package = pkgs.writeShellScriptBin "appimage-run" ''
        if [ "$2" = "--appimage-extract" ]; then
          if ${pkgs.dwarfs}/bin/dwarfsck --quiet --input "$1" >/dev/null 2>&1; then
            ${pkgs.coreutils}/bin/mkdir -p "$PWD/squashfs-root"
            exec ${pkgs.dwarfs}/bin/dwarfsextract \
              --input "$1" \
              --output "$PWD/squashfs-root" \
              --log-level=error
          fi

          exec ${pkgs.appimage-run}/bin/appimage-run -x "$PWD/squashfs-root" "$1"
        fi

        exec ${pkgs.appimage-run}/bin/appimage-run "$@"
      '';
    };
  };
}
