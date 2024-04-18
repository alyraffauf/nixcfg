{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  alyraffauf.user.dustin.enable = true;

  users.users.dustin.hashedPassword = "$y$j9T$OXQYhj4IWjRJWWYsSwcqf.$lCcdq9S7m0EAdej9KMHWj9flH8K2pUb2gitNhLTlLG/";

  home-manager.users.dustin = {
    imports = [../../homeManagerModules];
    home.username = "dustin";
    home.homeDirectory = "/home/dustin";

    home.stateVersion = "23.11";
    programs.home-manager.enable = true;

    alyraffauf.desktop.hyprland.hyprpaper.randomWallpaper.enable = false;

    alyraffauf.services.easyeffects = {
      enable = true;
      preset = "LoudnessEqualizer.json";
    };
  };

  users.users.aly.hashedPassword = "$y$j9T$VdtiEyMOegHpcUwgmCVFD0$K8Ne6.zk//VJNq2zxVQ0xE0Wg3LohvAQd3Xm9aXdM15";

  home-manager.users.aly = {
    imports = [../../homeManagerModules];
    home.username = "aly";
    home.homeDirectory = "/home/aly";

    home.stateVersion = "23.11";
    programs.home-manager.enable = true;

    alyraffauf.services.easyeffects = {
      enable = true;
      preset = "LoudnessEqualizer.json";
    };
  };
}
