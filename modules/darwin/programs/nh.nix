_: {
  flake.darwinModules.default = {pkgs, ...}: {
    environment = {
      systemPackages = with pkgs; [
        git
        nh
      ];

      variables = let
        FLAKE = "github:alyraffauf/hoenn";
      in {
        inherit FLAKE;
        NH_FLAKE = FLAKE;
      };
    };
  };
}
