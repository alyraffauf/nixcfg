_: {
  flake.systemModules.default = {
    nixpkgs = {
      config.allowUnfree = true;
      hostPlatform = "x86_64-linux";
    };
  };
}
