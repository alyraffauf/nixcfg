{
  config,
  lib,
  ...
}: {
  options.myNixOS.programs.virt-manager.enable = lib.mkEnableOption "virt-manager virtualization manager";

  config = lib.mkIf config.myNixOS.programs.virt-manager.enable {
    programs = {
      dconf.profiles.user.databases = lib.optionals (config.services.xserver.enable) [
        {
          settings = {
            "org/virt-manager/virt-manager/connections" = {
              autoconnect = ["qemu:///system"];
              uris = ["qemu:///system"];
            };
          };
        }
      ];

      virt-manager.enable = lib.mkDefault config.services.xserver.enable;
    };

    virtualisation.libvirtd.enable = true;
  };
}
