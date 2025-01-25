{lib, ...}: {
  config = {
    boot.kernel.sysctl = {
      # Improved file monitoring
      "fs.file-max" = lib.mkDefault 2097152;
      "fs.inotify.max_user_instances" = lib.mkOverride 100 8192;
      "fs.inotify.max_user_watches" = lib.mkOverride 100 524288;
    };

    services.bpftune.enable = true;

    systemd.oomd = {
      enable = true;
      enableRootSlice = true;
      enableSystemSlice = true;
      enableUserSlices = true;
    };

    zramSwap = {
      enable = lib.mkDefault true;
      algorithm = lib.mkDefault "zstd";
      priority = lib.mkDefault 100;
    };
  };
}
