{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.ar.apps.virt-manager.enable {
    programs.virt-manager.enable = true;

    virtualisation = {libvirtd.enable = true;};
  };
}
