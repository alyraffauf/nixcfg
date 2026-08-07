_: {
  flake.systemModules.default = {
    services.openssh = {
      enable = true;
      openFirewall = false;
      settings.PasswordAuthentication = false;
    };
  };
}
