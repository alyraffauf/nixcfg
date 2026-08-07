{
  config,
  lib,
  ...
}: {
  options.myNixOS.programs.systemd-boot.enable = lib.mkEnableOption "boot with systemd-boot";

  config = lib.mkIf config.myNixOS.programs.systemd-boot.enable {
    boot = {
      initrd.systemd.enable = lib.mkDefault true;

      loader = {
        efi.canTouchEfiVariables = lib.mkDefault true;

        systemd-boot = {
          enable = lib.mkDefault true;
          configurationLimit = lib.mkDefault 10;
        };
      };
    };
  };
}
