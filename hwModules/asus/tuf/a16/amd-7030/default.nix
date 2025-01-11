{
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    self.nixosModules.hw-common
    self.nixosModules.hw-common-amd-cpu
    self.nixosModules.hw-common-amd-gpu
    self.nixosModules.hw-common-bluetooth
    self.nixosModules.hw-common-laptop
    self.nixosModules.hw-common-ssd
  ];

  boot = {
    initrd.availableKernelModules = ["nvme" "sd_mod" "thunderbolt" "usb_storage" "xhci_pci"];
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    kernelParams = ["amdgpu.dcdebugmask=0x10"];
  };

  environment.systemPackages = with pkgs; [
    asusctl
    supergfxctl
  ];

  networking.networkmanager = {
    enable = true;

    wifi = {
      backend = "iwd";
      powersave = true;
    };
  };

  programs.rog-control-center.enable = true;

  services = {
    asusd = {
      enable = true;

      asusdConfig = ''
        (
              charge_control_end_threshold: 100,
              panel_od: false,
              boot_sound: false,
              mini_led_mode: false,
              disable_nvidia_powerd_on_battery: true,
              ac_command: "",
              bat_command: "",
              throttle_policy_linked_epp: true,
              throttle_policy_on_battery: Quiet,
              change_throttle_policy_on_battery: true,
              throttle_policy_on_ac: Balanced,
              change_throttle_policy_on_ac: true,
              throttle_quiet_epp: Power,
              throttle_balanced_epp: BalancePower,
              throttle_performance_epp: Performance,
          )
      '';

      fanCurvesConfig = ''
        (
              profiles: (
                  balanced: [
                      (
                          fan: CPU,
                          pwm: (5, 25, 66, 96, 114, 147, 170, 204),
                          temp: (20, 54, 63, 66, 70, 73, 80, 95),
                          enabled: true,
                      ),
                      (
                          fan: GPU,
                          pwm: (25, 45, 56, 81, 91, 124, 142, 173),
                          temp: (55, 60, 63, 66, 70, 73, 80, 95),
                          enabled: false,
                      ),
                  ],
                  performance: [
                      (
                          fan: CPU,
                          pwm: (5, 25, 79, 114, 147, 170, 204, 247),
                          temp: (20, 49, 60, 63, 65, 68, 71, 80),
                          enabled: true,
                      ),
                      (
                          fan: GPU,
                          pwm: (6, 56, 66, 91, 124, 142, 173, 204),
                          temp: (48, 57, 60, 63, 65, 68, 71, 80),
                          enabled: true,
                      ),
                  ],
                  quiet: [
                      (
                          fan: CPU,
                          pwm: (5, 25, 40, 53, 79, 107, 107, 147),
                          temp: (20, 62, 71, 74, 77, 80, 80, 97),
                          enabled: true,
                      ),
                      (
                          fan: GPU,
                          pwm: (2, 25, 35, 45, 66, 86, 86, 124),
                          temp: (65, 68, 71, 74, 77, 80, 80, 97),
                          enabled: false,
                      ),
                  ],
              ),
          )
      '';
    };

    supergfxd.enable = true;
  };
}
