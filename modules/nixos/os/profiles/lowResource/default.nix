{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myNixOS.profiles.lowResource.enable = lib.mkEnableOption "optimizations for resource-constrained servers";
  config = lib.mkIf config.myNixOS.profiles.lowResource.enable {
    boot = {
      kernelPackages = pkgs.linuxPackages_cachyos-server;
      tmp.cleanOnBoot = true;
    };

    documentation = {
      enable = false;
      nixos.enable = false;
    };

    services = {
      journald = {
        storage = "volatile";
        extraConfig = "SystemMaxUse=32M\nRuntimeMaxUse=32M";
      };

      smartd = {
        enable = true;
        defaults.monitored = "-a -o on -s (S/../.././02|L/../../7/04)";
      };
    };

    nix.settings.sandbox = false;

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
  };
}
