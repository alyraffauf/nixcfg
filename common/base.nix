{lib, ...}: {
  boot.loader.systemd-boot.configurationLimit = lib.mkDefault 10;
  environment.variables.FLAKE = lib.mkDefault "github:alyraffauf/nixcfg";

  programs = {
    dconf.enable = true; # Needed for home-manager

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    nh.enable = true;
  };

  networking.networkmanager.enable = true;

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;

      publish = {
        enable = true;
        addresses = true;
        userServices = true;
        workstation = true;
      };
    };

    openssh = {
      enable = true;
      openFirewall = true;
      settings.PasswordAuthentication = false;
    };
  };
}
