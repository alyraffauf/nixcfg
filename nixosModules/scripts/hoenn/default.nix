{
  pkgs,
  lib,
  config,
  ...
}: let
  hoenn = pkgs.writeShellScriptBin "hoenn" ''
    FLAKE="github:alyraffauf/nixcfg"
    HOST=${config.networking.hostName}
    FLAKE_SRC="https://github.com/alyraffauf/nixcfg.git"

    if [ "$1" = "sync" ]; then
      if [ "$2" == "" ] || [ "$2" == "now" ]; then
        sudo ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake $FLAKE#$HOST
        exit 0;
      elif [ "$2" == "boot" ]; then
        bin/sudo ${pkgs.nixos-rebuild}/bin/nixos-rebuild boot --flake $FLAKE#$HOST
        exit 0;
      fi
    elif [ "$1" == "gc" ]; then
      sudo ${pkgs.nix}/bin/nix-collect-garbage -d
      exit 0;
    elif [ "$1" == "clone" ]; then
      ${pkgs.git}/bin/git clone $FLAKE_SRC
      cd nixcfg
      exit 0;
    fi
  '';
in {
  options = {
    alyraffauf.scripts.hoenn.enable =
      lib.mkEnableOption "Enable \hoenn system configuration script";
  };

  config = lib.mkIf config.alyraffauf.scripts.hoenn.enable {
    # Packages that should be installed to the user profile.
    environment.systemPackages = with pkgs; [hoenn];
  };
}
