{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myNixOS.profiles.hardened.enable = lib.mkEnableOption "a paranoid set of security optimizations";

  config = lib.mkIf config.myNixOS.profiles.hardened.enable {
    boot = {
      kernel.sysctl."kernel.unprivileged_userns_clone" = 1; # Required for most browsers, disabled by default in hardened kernels.
      kernelPackages = pkgs.linuxPackages_cachyos-hardened;
      loader.systemd-boot.configurationLimit = 2;
    };

    environment.systemPackages = lib.optionals config.services.xserver.enable (with pkgs; [
      protonvpn-gui
      tor-browser
      veracrypt
    ]);

    services = {
      avahi.enable = lib.mkForce false;

      clamav = {
        daemon.enable = true;
        scanner.enable = true;
        updater.enable = true;
      };

      openssh.enable = lib.mkForce false;
    };

    zramSwap = {
      enable = lib.mkDefault true;
      algorithm = lib.mkDefault "lz4";
      priority = lib.mkDefault 100;
    };
  };
}
