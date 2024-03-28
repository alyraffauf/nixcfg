{ config, lib, pkgs, ... }:

{
  imports = [ ./syncthing ];

  userServices.syncthing.enable = lib.mkDefault true;
}
