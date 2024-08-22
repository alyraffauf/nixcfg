{
  pkgs,
  self,
  ...
}: let
  unstable = import self.inputs.nixpkgs-unstable {
    system = pkgs.system;
  };
in {
  nixpkgs = {
    config.allowUnfree = true; # Allow unfree packages

    overlays = [
      (final: prev: {
        rofi-bluetooth =
          prev.rofi-bluetooth.overrideAttrs
          (old: {
            version = "unstable-2024-07-25";

            src = pkgs.fetchFromGitHub {
              owner = "alyraffauf";
              repo = old.pname;
              rev = "50252e4a9aebe4899a6ef2f7bc11d91b7e4aa8ae";
              sha256 = "sha256-o0Sr3/888L/2KzZZP/EcXx+8ZUzdHB/I/VIeVuJvJks=";
            };
          });

        zed-editor = unstable.zed-editor;
      })
    ];
  };
}
