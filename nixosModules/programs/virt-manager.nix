{...}: {
  programs = {
    dconf.profiles.user.databases = [
      {
        settings = {
          "org/virt-manager/virt-manager/connections" = {
            autoconnect = ["qemu:///system"];
            uris = ["qemu:///system"];
          };
        };
      }
    ];

    virt-manager.enable = true;
  };

  virtualisation.libvirtd.enable = true;
}
