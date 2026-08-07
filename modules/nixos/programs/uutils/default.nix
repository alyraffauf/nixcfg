{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myNixOS.programs.uutils.enable = lib.mkEnableOption "rust uutils coreutils replacement";

  config = lib.mkIf config.myNixOS.programs.uutils.enable {
    environment.systemPackages = with pkgs; [
      (lib.hiPrio uutils-coreutils-noprefix)
      (lib.hiPrio uutils-diffutils)
      (lib.hiPrio uutils-findutils)
    ];
  };
}
