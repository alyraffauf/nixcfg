_: {
  flake.nixosModules.default = {pkgs, ...}: {
    programs.appimage = {
      enable = true;
      binfmt = true;
      package = pkgs.writeShellScriptBin "appimage-run" ''
        if [ "$2" = "--appimage-extract" ]; then
          exec ${pkgs.appimage-run}/bin/appimage-run -x "$PWD/squashfs-root" "$1"
        fi

        exec ${pkgs.appimage-run}/bin/appimage-run "$@"
      '';
    };
  };
}
