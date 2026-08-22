_: {
  flake = {
    nixosModules.default = {
      services.openssh = {
        enable = true;
        openFirewall = true;
        settings.PasswordAuthentication = false;
      };
    };

    darwinModules.default = {
      services.openssh.enable = true;
    };
  };
}
