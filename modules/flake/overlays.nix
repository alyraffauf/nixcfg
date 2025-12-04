{self, ...}: {
  flake.overlays = {
    default = _final: prev: let
      nixos-unstable = import self.inputs.nixpkgs-unstable {
        config.allowUnfree = true;
        inherit (prev) system;
      };
    in {
      inherit
        (nixos-unstable)
        cosmic-applets
        cosmic-applibrary
        cosmic-bg
        cosmic-comp
        cosmic-edit
        cosmic-files
        cosmic-greeter
        cosmic-icons
        cosmic-idle
        cosmic-initial-setup
        cosmic-launcher
        cosmic-notifications
        cosmic-osd
        cosmic-panel
        cosmic-player
        cosmic-randr
        cosmic-screenshot
        cosmic-session
        cosmic-settings
        cosmic-settings-daemon
        cosmic-store
        cosmic-term
        cosmic-wallpapers
        cosmic-workspaces-epoch
        ghostty
        obsidian
        signal-desktop-bin
        uutils-coreutils-noprefix
        uutils-diffutils
        uutils-findutils
        xdg-desktop-portal-cosmic
        zed-editor
        ;

      # https://github.com/NixOS/nixpkgs/issues/126590#issuecomment-3194531220
      kdePackages =
        prev.kdePackages
        // {
          plasma-workspace = let
            # the package we want to override
            basePkg = prev.kdePackages.plasma-workspace;

            # a helper package that merges all the XDG_DATA_DIRS into a single directory
            xdgdataPkg = prev.stdenv.mkDerivation {
              name = "${basePkg.name}-xdgdata";
              buildInputs = [basePkg];
              dontUnpack = true;
              dontFixup = true;
              dontWrapQtApps = true;
              installPhase = ''
                mkdir -p $out/share
                ( IFS=:
                  for DIR in $XDG_DATA_DIRS; do
                    if [[ -d "$DIR" ]]; then
                      cp -r $DIR/. $out/share/
                      chmod -R u+w $out/share
                    fi
                  done
                )
              '';
            };

            # undo the XDG_DATA_DIRS injection that is usually done in the qt wrapper
            # script and instead inject the path of the above helper package
            derivedPkg = basePkg.overrideAttrs {
              preFixup = ''
                for index in "''${!qtWrapperArgs[@]}"; do
                  if [[ ''${qtWrapperArgs[$((index+0))]} == "--prefix" ]] && [[ ''${qtWrapperArgs[$((index+1))]} == "XDG_DATA_DIRS" ]]; then
                    unset -v "qtWrapperArgs[$((index+0))]"
                    unset -v "qtWrapperArgs[$((index+1))]"
                    unset -v "qtWrapperArgs[$((index+2))]"
                    unset -v "qtWrapperArgs[$((index+3))]"
                  fi
                done
                qtWrapperArgs=("''${qtWrapperArgs[@]}")
                qtWrapperArgs+=(--prefix XDG_DATA_DIRS : "${xdgdataPkg}/share")
                qtWrapperArgs+=(--prefix XDG_DATA_DIRS : "$out/share")
              '';
            };
          in
            derivedPkg;
        };
    };
  };
}
