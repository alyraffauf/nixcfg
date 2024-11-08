{
  lib,
  pkgs,
  ...
}: {
  services = {
    power-profiles-daemon.enable = lib.mkDefault true;

    udev.extraRules = ''
      SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_NAME}=="ACAD", ATTR{online}=="1", ACTION=="change", RUN+="${lib.getExe pkgs.power-profiles-daemon} set balanced"
      SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_NAME}=="ACAD", ATTR{online}=="0", ACTION=="change", RUN+="${lib.getExe pkgs.power-profiles-daemon} set power-saver"
    '';

    upower.enable = lib.mkDefault true;
  };
}
