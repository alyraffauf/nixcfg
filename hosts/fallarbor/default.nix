# Framework 13 with 11th gen Intel Core i5, 16GB RAM, 512GB SSD.
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./disko.nix
    ./hardware-configuration.nix # Include the results of the hardware scan.
    ./home.nix
  ];

  boot = {
    # Bootloader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    # Use latest Linux kernel.
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking.hostName = "fallarbor"; # Define your hostname.

  services = {
    fwupd.enable = true;
  };

  alyraffauf = {
    services = {
      flatpak.enable = true;
    };
    system = {
      plymouth.enable = true;
      zramSwap = {enable = true;};
    };
    user = {
      aly.enable = true;
      dustin.enable = true;
    };
    desktop = {
      enable = true;
      greetd.enable = true;
      hyprland.enable = true;
    };
    apps = {
      steam.enable = true;
    };
  };

  users.users.dustin.hashedPassword = "$y$j9T$OXQYhj4IWjRJWWYsSwcqf.$lCcdq9S7m0EAdej9KMHWj9flH8K2pUb2gitNhLTlLG/";
  users.users.aly.hashedPassword = "$y$j9T$Ug0ZLHQQuRciFJDgOI6r00$eHc.KyQY0oU4k0LKRiZiGWJ19jkKNWHpOoyCJbtJif8";

  system.stateVersion = "23.11";
}
