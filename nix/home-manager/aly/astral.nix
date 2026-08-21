_: {
  flake.homeModules.aly = {pkgs, ...}: {
    home.packages = with pkgs; [
      python3
    ];

    programs = {
      ruff.enable = true;
      ty.enable = true;
      uv.enable = true;
    };
  };
}
