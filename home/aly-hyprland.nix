{ config, pkgs, ... }:

{
  imports =
    [ ./common.nix ./common-gui.nix ./shell ./hypr ./waybar ./mako ./bemenu ];
}
