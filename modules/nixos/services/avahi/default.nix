{
  config,
  lib,
  ...
}: {
  options.myNixOS.services.avahi.enable = lib.mkEnableOption "avahi networking";

  config = lib.mkIf config.myNixOS.services.avahi.enable {
    services.avahi = {
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
  };
}
