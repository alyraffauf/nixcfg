_: {
  flake.nixosModules.aly = {pkgs, ...}: {
    users.users.aly.packages = with pkgs; [
      age
      duf
      dust
      jq
      just
      yq
    ];
  };
}
