# Framework 13 with 11th gen Intel Core i5, 16GB RAM, 512GB SSD.
{
  config,
  self,
  ...
}: {
  imports = [
    ./disko.nix
    ./home.nix
    ./secrets.nix
    ./stylix.nix
    self.nixosModules.common-base
    self.nixosModules.common-locale
    self.nixosModules.common-nix
    self.nixosModules.common-pkgs
    self.nixosModules.common-systemd-boot
    self.nixosModules.common-wifi-profiles
    self.nixosModules.hw-framework-13-intel-11th
    self.nixosModules.nixos-desktop-kde
    self.nixosModules.nixos-profiles-desktop
    self.nixosModules.nixos-programs-firefox
    self.nixosModules.nixos-programs-steam
    self.nixosModules.nixos-services-sddm
  ];

  environment.variables.GDK_SCALE = "1.5";
  networking.hostName = "fallarbor";
  system.stateVersion = "24.05";

  ar.users = {
    aly = {
      enable = true;
      password = "$y$j9T$0p6rc4p5sn0LJ/6XyAGP7.$.wmTafwMMscdW1o8kqqoHJP7U8kF.4WBmzzcPYielR3";

      syncthing = {
        enable = true;
        certFile = config.age.secrets.syncthingCert.path;
        keyFile = config.age.secrets.syncthingKey.path;
      };
    };

    dustin = {
      enable = true;
      password = "$y$j9T$OXQYhj4IWjRJWWYsSwcqf.$lCcdq9S7m0EAdej9KMHWj9flH8K2pUb2gitNhLTlLG/";
    };
  };
}
