# Lenovo Thinkpad T440p with a Core i5 4210M, 16GB RAM, 512GB SSD.
{
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./home.nix
    ./secrets.nix
    ./stylix.nix
    self.nixosModules.disko-luks-btrfs-subvolumes
    self.nixosModules.hardware-lenovo-thinkpad-T440p
    self.nixosModules.locale-en-us
  ];

  boot = {
    initrd.systemd.enable = lib.mkDefault true;

    loader = {
      efi.canTouchEfiVariables = lib.mkDefault true;

      systemd-boot = {
        enable = lib.mkDefault true;
        configurationLimit = lib.mkDefault 10;
      };
    };

    kernelPackages = pkgs.linuxPackages_cachyos-hardened;
  };

  environment = {
    memoryAllocator.provider = "graphene-hardened";

    systemPackages = with pkgs; [
      protonvpn-gui
      tor-browser
    ];

    variables.GDK_SCALE = "1.25";
  };

  networking.hostName = "rustboro";

  programs = {
    firefox = {
      enable = true;
      package = pkgs.librewolf;
    };

    zsh.enable = true;
  };

  services = {
    avahi.enable = lib.mkForce false;
    openssh.enable = lib.mkForce false;
    xserver.xkb.options = "ctrl:nocaps";
  };

  system.stateVersion = "25.05";
  time.timeZone = "America/New_York";

  users = {
    defaultUserShell = pkgs.zsh;
    mutableUsers = false;

    users.aly = {
      description = "Aly Raffauf";

      extraGroups = [
        "dialout"
        "lp"
        "networkmanager"
        "plugdev"
        "scanner"
        "video"
        "wheel"
      ];

      hashedPassword = "$y$j9T$VMCXwk0X5m6xW6FGLc39F/$r9gmyeB70RCq3k4oLPHFZyy7wng6WyX2xYMKLO/A.rB";
      isNormalUser = true;

      shell = pkgs.zsh;
      uid = 1000;
    };
  };

  myDisko.installDrive = "/dev/sda";

  myNixOS = {
    desktop.gnome.enable = true;

    profiles = {
      autoUpgrade.enable = true;
      base.enable = true;
      btrfs.enable = true;
    };

    programs = {
      lanzaboote.enable = true;
      nix.enable = true;
    };

    services.gdm.enable = true;
  };
}
