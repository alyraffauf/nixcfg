{pkgs, ...}: {
  boot = {
    consoleLogLevel = 0;
    initrd.verbose = false;
    plymouth.enable = true;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  programs.system-config-printer.enable = true;

  services = {
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true; # Mount, trash, etc.
    libinput.enable = true;

    pipewire = {
      enable = true;

      alsa = {
        enable = true;
        support32Bit = true;
      };

      pulse.enable = true;
    };

    printing.enable = true;

    pulseaudio = {
      package = pkgs.pulseaudioFull; # Use extra Bluetooth codecs like aptX

      extraConfig = ''
        load-module module-bluetooth-discover
        load-module module-bluetooth-policy
        load-module module-switch-on-connect
      '';

      support32Bit = true;
    };

    system-config-printer.enable = true;

    xserver = {
      enable = true;
      excludePackages = with pkgs; [xterm];
    };
  };
}