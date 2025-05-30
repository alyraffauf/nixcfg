{
  config,
  lib,
  ...
}: {
  options.myNixOS.profiles.lowResource.enable = lib.mkEnableOption "optimizations for resource-constrained servers";
  config = lib.mkIf config.myNixOS.profiles.lowResource.enable {
    boot.tmp.cleanOnBoot = true;

    documentation = {
      enable = false;
      nixos.enable = false;
    };

    services.journald = {
      storage = "volatile";
      extraConfig = "SystemMaxUse=32M\nRuntimeMaxUse=32M";
    };

    nix = {
      gc.options = lib.mkForce "--delete-older-than 1d";
      settings.sandbox = false;
    };

    systemd = {
      coredump.enable = false;

      oomd = {
        enable = true;
        enableRootSlice = true;
        enableSystemSlice = true;
        enableUserSlices = true;
      };
    };

    zramSwap = {
      enable = lib.mkDefault true;
      algorithm = lib.mkDefault "zstd";
      priority = lib.mkDefault 100;
    };

    myNixOS.services.fail2ban.enable = true;
  };
}
