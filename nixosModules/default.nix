{ config, pkgs, ... }:

{
  imports = [ ./desktopConfig ./homeLab ./programs ./systemConfig ./userConfig ];

}