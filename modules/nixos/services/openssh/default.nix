{
  config,
  lib,
  ...
}: {
  options.myNixOS.services.openssh.enable = lib.mkEnableOption "openssh server";

  config = lib.mkIf config.myNixOS.services.openssh.enable {
    services.openssh = {
      enable = true;
      openFirewall = true;
      settings.PasswordAuthentication = false;
    };
  };
}
