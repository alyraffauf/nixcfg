self: {
  lib,
  pkgs,
  ...
}: {
  boot = {
    consoleLogLevel = 0;
    initrd.verbose = false;

    plymouth = {
      enable = true;
      font = "${pkgs.nerdfonts.override {fonts = ["Noto"];}}/share/fonts/truetype/NerdFonts/NotoSansNerdFont-Regular.ttf";
    };
  };

  console.useXkbConfig = true;
  hardware.keyboard.qmk.enable = true;

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    nh.enable = true;
  };

  nix = {
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
      persistent = true;
      randomizedDelaySec = "60min";
    };

    # Run GC when there is less than 100MiB left.
    extraOptions = ''
      min-free = ${toString (100 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
    '';

    optimise.automatic = true;

    settings = {
      auto-optimise-store = false;
      experimental-features = ["nix-command" "flakes"];
    };
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        addresses = true;
        userServices = true;
        workstation = true;
      };
    };

    logind.extraConfig = ''
      # Don't shutdown when power button is short-pressed
      HandlePowerKey=suspend
      HandlePowerKeyLongPress=poweroff
    '';

    openssh = {
      enable = true;
      openFirewall = true;
      settings.PasswordAuthentication = false;
    };

    printing.enable = true;

    system-config-printer.enable = true;
  };

  sound.enable = true;

  zramSwap = {
    enable = lib.mkDefault true;
    memoryPercent = lib.mkDefault 50;
  };
}
