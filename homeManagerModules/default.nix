{ config, pkgs, ... }:

{
  imports = [ ./cliApps ./guiApps ./desktopEnv ./userServices ];
}
