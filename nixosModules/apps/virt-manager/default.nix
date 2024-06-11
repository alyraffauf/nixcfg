{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.apps.virt-manager.enable {
    programs.virt-manager.enable = true;

    virtualisation = {libvirtd.enable = true;};
  };
}
