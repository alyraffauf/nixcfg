{ pkgs, lib, config, ... }: {

  imports = [ ./aly ./dustin ];

  userConfig.aly.enable = lib.mkDefault true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
