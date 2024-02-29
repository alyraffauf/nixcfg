{ config, pkgs, ... }:

{
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];
}
