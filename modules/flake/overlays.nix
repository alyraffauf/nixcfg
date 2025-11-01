{self, ...}: {
  flake.overlays = {
    default = _final: prev: let
      nixos-unstable-small = import self.inputs.nixpkgs-unstable-small {
        config.allowUnfree = true;
        inherit (prev) system;
      };
    in {
      inherit
        (nixos-unstable-small)
        cosmic-bg
        cosmic-osd
        zed-editor
        cosmic-comp
        cosmic-edit
        cosmic-idle
        cosmic-term
        cosmic-files
        cosmic-icons
        cosmic-panel
        cosmic-randr
        cosmic-store
        cosmic-player
        cosmic-applets
        cosmic-greeter
        cosmic-session
        cosmic-launcher
        cosmic-settings
        cosmic-applibrary
        cosmic-screenshot
        cosmic-wallpapers
        cosmic-initial-setup
        cosmic-notifications
        cosmic-settings-daemon
        cosmic-workspaces-epoch
        xdg-desktop-portal-cosmic
        ;
    };
  };
}
