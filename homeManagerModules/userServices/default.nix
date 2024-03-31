{ config, lib, pkgs, ... }:

{
  imports = [ ./syncthing ./easyeffects ];

  userServices.syncthing.enable = lib.mkDefault true;
}
