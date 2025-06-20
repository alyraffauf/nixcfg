{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myNixOS.programs.retroarch = {
    enable = lib.mkEnableOption "RetroArch emulator";

    cores = lib.mkOption {
      description = "RetroArch cores to install.";
      default = [];
      type = lib.types.listOf lib.types.package;
    };

    session.enable = lib.mkEnableOption "RetroArch desktop session.";
  };

  config = lib.mkIf config.myNixOS.programs.retroarch.enable {
    environment.systemPackages =
      if config.retroarch.cores != []
      then
        with pkgs; [
          (retroarch-bare.wrapper {
            cores = config.retroarch.cores;
          })
        ]
      else [pkgs.retroarch];

    services.xserver.desktopManager.retroarch = lib.mkIf (config.retroarch.session.enable) {enable = true;};
  };
}
