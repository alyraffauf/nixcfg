{
  config,
  lib,
  self,
  ...
}: {
  imports = [
    self.inputs.jovian.nixosModules.default
  ];

  options.myNixOS.desktop.steamos = {
    enable = lib.mkEnableOption "SteamOS desktop environment";

    user = lib.mkOption {
      type = lib.types.str;
      default = "steam";
      description = "User to run SteamOS as.";
    };
  };

  config = lib.mkIf config.myNixOS.desktop.steamos.enable {
    services.handheld-daemon.user = lib.mkDefault config.myNixOS.desktop.steamos.user;

    jovian = {
      decky-loader = {
        enable = true;
        user = config.myNixOS.desktop.steamos.user;
      };

      steam = {
        enable = true;
        autoStart = true;
        desktopSession = lib.mkDefault "plasma";
        user = config.myNixOS.desktop.steamos.user;
      };

      steamos = {
        enableAutoMountUdevRules = true;
        enableBluetoothConfig = true;
        enableDefaultCmdlineConfig = true;
        enableProductSerialAccess = true;
        enableVendorRadv = true;
        useSteamOSConfig = false;
      };
    };

    myNixOS = {
      desktop = {
        enable = true;
        kde.enable = true;
      };

      profiles = {
        desktop.enable = true;
        gaming.enable = true;
      };
    };
  };
}
