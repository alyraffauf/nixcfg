{ config, pkgs, ... }:

{
    boot.initrd.verbose = false;
    boot.consoleLogLevel = 0;

    boot.plymouth.enable = true;
}
