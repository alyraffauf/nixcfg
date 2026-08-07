_: {
  flake.nixosModules.default = {
    programs.appimage = {
      enable = true;
      binfmt = true;
    };
  };
}
