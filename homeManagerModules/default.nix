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
    documents = "${config.home.homeDirectory}/docs";
    download = "${config.home.homeDirectory}/downloads";
    music = "${config.home.homeDirectory}/music";
    videos = "${config.home.homeDirectory}/vids";
    pictures = "${config.home.homeDirectory}/pics";
    extraConfig = { XDG_SRC_DIR = "${config.home.homeDirectory}/src"; };
  };
}
