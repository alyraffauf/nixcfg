{ config, pkgs, ... }:

{
  imports = [ # Include X settings.
    ./desktop.nix
  ];

  services.xserver.displayManager.lightdm = {
    enable = true;
    greeters.slick = {
      enable = true;
      theme.name = "Catppuccin-Latte-Compact-Green-Light";
      theme.package = pkgs.catppuccin-gtk.override {
        accents = [ "green" ];
        size = "compact";
        variant = "latte";
        tweaks = [ "normal" ];
      };
      iconTheme.name = "Papirus-Light";
      iconTheme.package = pkgs.catppuccin-papirus-folders.override {
        flavor = "latte";
        accent = "green";
      };
      font.name = "NotoSansM Nerd Font Mono";

      cursorTheme.package = pkgs.vanilla-dmz;
      cursorTheme.name = "Vanilla-DMZ-AA";
      cursorTheme.size = 32;
      
      extraConfig = ''
        background=#000000
        enable-hidpi=on
      '';
    };
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
