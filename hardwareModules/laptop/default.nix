{
  config,
  lib,
  pkgs,
  ...
}: let
  pp-adjuster = pkgs.writeShellScriptBin "pp-adjuster" ''
    current_profile=$(${lib.getExe' pkgs.power-profiles-daemon "powerprofilesctl"} get | tr -d '[:space:]')
    if [ "$current_profile" == "power-saver" ]; then
        ${lib.getExe' pkgs.power-profiles-daemon "powerprofilesctl"} set balanced
    elif [ "$current_profile" == "balanced" ]; then
        ${lib.getExe' pkgs.power-profiles-daemon "powerprofilesctl"} set performance
    elif [ "$current_profile" == "performance" ]; then
        ${lib.getExe' pkgs.power-profiles-daemon "powerprofilesctl"} set power-saver
    fi
    new_profile=$(${lib.getExe' pkgs.power-profiles-daemon "powerprofilesctl"} get | tr -d '[:space:]')
    ${lib.getExe pkgs.libnotify} "Power profile set to $new_profile."
  '';
in {
  config = lib.mkIf config.ar.hardware.laptop {
    environment.systemPackages =
      lib.optional (config.services.power-profiles-daemon.enable)
      pp-adjuster;

    services = {
      power-profiles-daemon.enable = true;
      upower.enable = true;

      tlp = {
        enable = !config.services.power-profiles-daemon.enable;
        settings = {
          BAY_POWEROFF_ON_AC = 0;
          BAY_POWEROFF_ON_BAT = 1;
          CPU_BOOST_ON_AC = 1;
          CPU_BOOST_ON_BAT = 0;
          CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
          CPU_HWP_DYN_BOOST_ON_AC = 1;
          CPU_HWP_DYN_BOOST_ON_BAT = 0;
          PCIE_ASPM_ON_AC = "default";
          PCIE_ASPM_ON_BAT = "powersupersave";
          PLATFORM_PROFILE_ON_AC = "balanced";
          PLATFORM_PROFILE_ON_BAT = "low-power";
          RESTORE_DEVICE_STATE_ON_STARTUP = 1;
          TLP_DEFAULT_MODE = "AC";
          TLP_PERSISTENT_DEFAULT = 0;
        };
      };
    };
  };
}
