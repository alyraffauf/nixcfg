{
  config,
  lib,
  ...
}: {
  imports = [
    ./equalizer.nix
  ];

  options.myHardware.lenovo.thinkpad.X1.gen-9.enable = lib.mkEnableOption "Lenovo ThinkPad X1 Carbon Gen 9 hardware configuration.";

  config = lib.mkIf config.myHardware.lenovo.thinkpad.X1.gen-9.enable {
    boot.initrd.availableKernelModules = [
      "nvme"
      "thunderbolt"
    ];

    hardware.trackpoint = {
      enable = true;
      emulateWheel = true;
      sensitivity = 64;
      speed = 40;
    };

    # home-manager = {
    #   sharedModules = [
    #     {
    #       services.easyeffects = {
    #         enable = true;
    #         preset = "X1C.json";
    #       };

    #       xdg.configFile."easyeffects/output/X1C.json".source = ./easyeffects.json;
    #     }
    #   ];
    # };

    services = {
      fprintd.enable = true;
      fwupd.enable = true;
    };

    myHardware = {
      intel = {
        cpu.enable = true;
        gpu.enable = true;
      };

      profiles = {
        base.enable = true;
        laptop.enable = true;
      };
    };
  };
}
