{ config, pkgs, ... }:

{
  imports =
    [ ./common.nix ./common-gui.nix ./hypr ./waybar ./mako ./bemenu ./fuzzel ];
}
