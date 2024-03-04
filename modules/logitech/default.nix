{ config, pkgs, ... }:

{
    # Add support for logitech unifying receivers.
    hardware.logitech.wireless.enable = true;
    hardware.logitech.wireless.enableGraphical = true;
}
