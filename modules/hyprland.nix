{ config, pkgs, ... }:

{
  imports = [ # Include X settings.
    ./desktop.nix
  ];

  services.xserver.displayManager.lightdm = {
    enable = true;
    greeters.slick = {
      enable = true;
      theme.name = "Catppuccin-Frappe-Compact-Mauve-Dark";
      theme.package = pkgs.catppuccin-gtk.override {
        accents = [ "mauve" ];
        size = "compact";
        variant = "frappe";
        tweaks = [ "normal" ];
      };
      iconTheme.name = "Papirus-Dark";
      iconTheme.package = pkgs.catppuccin-papirus-folders.override {
        flavor = "frappe";
        accent = "mauve";
      };
      font.name = "NotoSans Nerd Font Regular";

      cursorTheme.package = pkgs.catppuccin-cursors.latteDark;
      cursorTheme.name = "Catppuccin-Frappe-Dark-Cursors";
      cursorTheme.size = 32;

      extraConfig = ''
        background=#ca9ee6
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
