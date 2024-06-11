{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.scripts.hoenn.enable {
    environment.systemPackages = [
      (pkgs.writeShellScriptBin "hoenn" ''
        FLAKE=''${2:-"github:alyraffauf/nixcfg"}
        HOST=''${HOST:-${config.networking.hostName}}
        GIT=https://''${FLAKE//:/\.com\/}.git

        if [ "$1" == "sync" ]; then
          sudo ${lib.getExe pkgs.nixos-rebuild} switch --flake $FLAKE#$HOST
          exit 0;
        elif [ "$1" == "boot" ]; then
          sudo ${lib.getExe pkgs.nixos-rebuild} boot --flake $FLAKE#$HOST
          exit 0;
        elif [ "$1" == "gc" ]; then
          sudo ${lib.getExe' pkgs.nix "nix-collect-garbage"} -d
          exit 0;
        elif [ "$1" == "clone" ]; then
          ${lib.getExe pkgs.git} clone $GIT
          cd nixcfg
          exit 0;
        fi
      '')
    ];
  };
}
