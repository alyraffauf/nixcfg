{ config, pkgs, ... }:

{
  imports = [ ./cliApps ./guiApps ./desktopEnv ./userServices ];

  nixpkgs = {
    # Configure nixpkgs instance
    config = {
      # Enableunfree packages
      allowUnfree = true;
    };
  };
  
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "${config.home.homeDirectory}/dsktp";
    documents = "${config.home.homeDirectory}/docs";
    download = "${config.home.homeDirectory}/dwnlds";
    music = "${config.home.homeDirectory}/music";
    videos = "${config.home.homeDirectory}/vids";
    pictures = "${config.home.homeDirectory}/pics";
    publicShare = "${config.home.homeDirectory}/pub";
    templates = "${config.home.homeDirectory}/tmplts";
    extraConfig = { XDG_SRC_DIR = "${config.home.homeDirectory}/src"; };
  };
}
