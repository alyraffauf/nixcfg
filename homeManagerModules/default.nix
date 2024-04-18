{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [./apps ./desktop ./services];

  nixpkgs = {
    # Configure nixpkgs instance
    config = {
      # Enable unfree packages
      allowUnfree = true;
    };
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = lib.mkDefault "${config.home.homeDirectory}/dsktp";
    documents = lib.mkDefault "${config.home.homeDirectory}/docs";
    download = lib.mkDefault "${config.home.homeDirectory}/dwnlds";
    music = lib.mkDefault "${config.home.homeDirectory}/music";
    videos = lib.mkDefault "${config.home.homeDirectory}/vids";
    pictures = lib.mkDefault "${config.home.homeDirectory}/pics";
    publicShare = lib.mkDefault "${config.home.homeDirectory}/pub";
    templates = lib.mkDefault "${config.home.homeDirectory}/tmplts";
    extraConfig = {XDG_SRC_DIR = "${config.home.homeDirectory}/src";};
  };

  xdg.dataFile."backgrounds/".source = ../files/wallpapers;
}
