_: let
  variables = let
    FLAKE = "github:alyraffauf/hoenn";
  in {
    inherit FLAKE;
    NH_FLAKE = FLAKE;
  };

  environmentFor = systemPackages: {
    inherit systemPackages;
    inherit variables;
  };
in {
  flake = {
    nixosModules.default = {pkgs, ...}: {
      environment = environmentFor [pkgs.git];
      programs.nh.enable = true;
    };

    homeModules.aly = {pkgs, ...}: {
      home = {
        packages = [pkgs.nh];
        sessionVariables = variables;
      };
    };
  };
}
