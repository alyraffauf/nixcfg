{ config, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.aly = {
    isNormalUser = true;
    description = "Dustin Raffauf";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };
}
