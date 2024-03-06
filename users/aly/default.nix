{ config, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.aly = {
    isNormalUser = true;
    description = "Aly Raffauf";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" ];
  };
}
