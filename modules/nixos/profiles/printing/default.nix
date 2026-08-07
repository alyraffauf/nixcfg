{
  config,
  lib,
  ...
}: {
  options.myNixOS.profiles.printing.enable = lib.mkEnableOption "printing support";

  config = lib.mkIf config.myNixOS.profiles.printing.enable {
    programs.system-config-printer.enable = true;

    services = {
      printing.enable = true;
      system-config-printer.enable = true;
    };

    myNixOS.services.avahi.enable = true;
  };
}
