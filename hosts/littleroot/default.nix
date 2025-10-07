{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  image.baseName = lib.mkForce "littleroot";
  networking.hostName = "littleroot";
  nixpkgs.hostPlatform = "x86_64-linux";

  specialisation = {
    text.configuration = {
      isoImage.showConfiguration = true;
      isoImage.configurationName = "Text (Linux ${config.boot.kernelPackages.kernel.version})";
    };

    gnome_latest_kernel.configuration = {
      imports = [
        "${modulesPath}/installer/cd-dvd/installation-cd-graphical-gnome.nix"
      ];

      isoImage.showConfiguration = true;
      isoImage.configurationName = "GNOME (Linux ${config.boot.kernelPackages.kernel.version})";

      myNixOS = {
        desktop.gnome.enable = true;
        programs.firefox.enable = true;
        profiles.workstation.enable = true;
      };
    };
  };

  myNixOS = {
    profiles.iso.enable = true;
    programs.nix.enable = true;
  };

  myUsers.root.enable = true;
}
