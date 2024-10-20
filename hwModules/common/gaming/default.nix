{lib, ...}: {
  boot.kernel.sysctl = {
    # Improved file monitoring
    "fs.inotify.max_user_instances" = 8192;
    "fs.inotify.max_user_watches" = 524288;

    # Disable watchdogs for maximum performance at the cost of resiliency
    "kernel.nmi_watchdog" = 0;
    "kernel.soft_watchdog" = 0;
    "kernel.split_lock_mitigate" = 0;
    "kernel.watchdog" = 0;

    # Network optimizations
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.ipv4.tcp_mtu_probing" = lib.mkForce 1;

    # Memory management
    "vm.dirty_background_bytes" = 134217728;
    "vm.dirty_bytes" = 268435456;
    "vm.max_map_count" = lib.mkForce 2147483642;
    "vm.page-cluster" = 0;
    "vm.swappiness" = 180;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
  };

  services.udev.extraRules = ''
    # Significantly improved I/O performance
    ## SSD
    ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="kyber"

    ## NVME
    ACTION=="add|change", KERNEL=="nvme[0-9]n[0-9]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="kyber"

    ## MicroSD
    ACTION=="add|change", KERNEL=="mmcblk[0-9]p[0-9]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="bfq"

    ## HDD
    ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
  '';
}
