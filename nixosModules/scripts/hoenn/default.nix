{
  pkgs,
  lib,
  config,
  ...
}: let
  hoenn = pkgs.writeShellScriptBin "hoenn" ''
    FLAKE=''${2:-"github:alyraffauf/nixcfg"}
    HOST=''${HOST:-${config.networking.hostName}}
    GIT=https://''${FLAKE//:/\.com\/}.git

    if [ "$1" == "sync" ]; then
      sudo ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake $FLAKE#$HOST
      exit 0;
    elif [ "$1" == "boot" ]; then
      bin/sudo ${pkgs.nixos-rebuild}/bin/nixos-rebuild boot --flake $FLAKE#$HOST
      exit 0;
    elif [ "$1" == "gc" ]; then
      sudo ${pkgs.nix}/bin/nix-collect-garbage -d
      exit 0;
    elif [ "$1" == "clone" ]; then
      ${pkgs.git}/bin/git clone $GIT
      cd nixcfg
      exit 0;
    fi
  '';
in {
  options = {
    alyraffauf.scripts.hoenn.enable =
      lib.mkEnableOption "Enable hoenn system configuration script";
  };

  config = lib.mkIf config.alyraffauf.scripts.hoenn.enable {
    environment.systemPackages = with pkgs; [hoenn];
  };
}
