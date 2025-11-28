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
    };
  };
}
