{pkgs, ...}: {
  boot = {
    consoleLogLevel = 0;
    initrd.verbose = false;
    plymouth.enable = true;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };

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
    system-config-printer.enable = true;

    xserver = {
      enable = true;
      excludePackages = with pkgs; [xterm];
    };
  };
}
