{ config, pkgs, ... }:

{
  imports = [ # Include X settings.
    ./desktop.nix
  ];

  services.xserver.displayManager.lightdm = {
    enable = true;
    greeters.slick = {
      enable = true;
      extraConfig = ''enable-hidpi=on'';
  };
  programs.hyprland.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  services.gnome.gnome-keyring.enable = true;

  programs.xfconf.enable = true;
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-volman ];
  };
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
