{ config, pkgs, ... }:

{
  imports = [ ./desktopConfig ./homeLab ./apps ./systemConfig ./userConfig ];

}
