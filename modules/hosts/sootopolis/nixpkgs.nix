{
  flake.systemModules.sootopolis = {
    nixpkgs = {
      config.allowUnfree = true;
      hostPlatform = "x86_64-linux";
    };
  };
}
