_: let
  shellPackages = pkgs:
    with pkgs; [
      age
      duf
      dust
      jq
      just
      yq
    ];
in {
  flake = {
    nixosModules.aly = {pkgs, ...}: {
      users.users.aly.packages = shellPackages pkgs;
    };

    homeModules.aly = {pkgs, ...}: {
      home.packages = shellPackages pkgs;
    };
  };
}
