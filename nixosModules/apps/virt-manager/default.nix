{ pkgs, lib, config, ... }: {

  options = {
    apps.virt-manager.enable =
      lib.mkEnableOption "Enables virt-manager with TPM and EFI support.";
  };

  config = lib.mkIf config.apps.virt-manager.enable {

    programs.virt-manager.enable = true;

    virtualisation = { libvirtd.enable = true; };

  };
}
