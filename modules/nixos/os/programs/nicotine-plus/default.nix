{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myNixOS.programs.nicotine-plus.enable = lib.mkEnableOption "nicotine-plus";

  config = lib.mkIf config.myNixOS.programs.nicotine-plus.enable {
    environment.systemPackages = [pkgs.nicotine-plus];

    networking = {
      firewall.allowedTCPPortRanges = [
        # Soulseek
        {
          from = 2234;
          to = 2239;
        }
      ];
      firewall.allowedUDPPortRanges = [
        # Soulseek
        {
          from = 2234;
          to = 2239;
        }
      ];
    };
  };
}
