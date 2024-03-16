{ config, pkgs, ... }:

{
    boot = {
        consoleLogLevel = 0;
        initrd.verbose = false;
        plymouth.enable = true;
    };
}
