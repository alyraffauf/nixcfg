_: {
  flake.nixosModules.default = {pkgs, ...}: {
    environment = {
      systemPackages = with pkgs; [
        git
      ];

      variables = let
        FLAKE = "github:alyraffauf/hoenn";
      in {
        inherit FLAKE;
        NH_FLAKE = FLAKE;
      };
    };

    programs.nh = {
      enable = true;
    };
  };
}
