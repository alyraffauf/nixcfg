{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.apps.virt-manager.enable =
      lib.mkEnableOption "Enables virt-manager with TPM and EFI support.";
  };

  config = lib.mkIf config.alyraffauf.apps.virt-manager.enable {
    programs.virt-manager.enable = true;

    virtualisation = {libvirtd.enable = true;};
  };
}
