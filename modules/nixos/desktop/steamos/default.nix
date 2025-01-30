{
  config,
  lib,
  self,
  ...
}: {
  imports = [
    self.nixosModules.nixos-desktop
    self.nixosModules.nixos-desktop-kde
    self.nixosModules.nixos-profiles-gaming
    self.nixosModules.nixos-programs-steam
  ];

  options.myNixOS.steamos.user = lib.mkOption {
    type = lib.types.str;
    default = "steam";
    description = "User to run SteamOS as.";
  };

  config = {
    services.handheld-daemon.user = lib.mkDefault config.myNixOS.steamos.user;

    jovian = {
      decky-loader = {
        enable = true;
        user = config.myNixOS.steamos.user;
      };

      steam = {
        enable = true;
        autoStart = true;
        desktopSession = lib.mkDefault "plasma";
        user = config.myNixOS.steamos.user;
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
  };
}
