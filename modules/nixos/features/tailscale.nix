_: {
  flake.nixosModules.tailscale = {
    config,
    pkgs,
    self,
    ...
  }: {
    environment.systemPackages = [pkgs.nfs-utils];

    fileSystems = {
      "/mnt/Data" = {
        device = "jubilife:/mnt/Data";
        fsType = "nfs";
        options = [
          "default"
          "noatime"
          "nofail"
          "retrans=2"
          "rsize=1048576"
          "wsize=1048576"
          "x-systemd.after=network-online.target"
          "x-systemd.after=tailscaled.service"
          "x-systemd.automount"
          "x-systemd.device-timeout=5s"
          "x-systemd.idle-timeout=60"
          "x-systemd.mount-timeout=5s"
        ];
      };

      "/mnt/Media" = {
        device = "jubilife:/mnt/Media";
        fsType = "nfs";
        options = [
          "default"
          "noatime"
          "nofail"
          "retrans=2"
          "rsize=1048576"
          "wsize=1048576"
          "x-systemd.after=network-online.target"
          "x-systemd.after=tailscaled.service"
          "x-systemd.automount"
          "x-systemd.device-timeout=5s"
          "x-systemd.idle-timeout=60"
          "x-systemd.mount-timeout=5s"
        ];
      };
    };

    networking.firewall = {
      allowedUDPPorts = [config.services.tailscale.port];
      trustedInterfaces = [config.services.tailscale.interfaceName];
    };

    sops.secrets.tailscale-auth-key.sopsFile = self + "/secrets/tailscale.yaml";

    services.tailscale = {
      authKeyFile = config.sops.secrets.tailscale-auth-key.path;
      enable = true;
      extraUpFlags = ["--ssh" "--accept-routes"];
      openFirewall = true;
      useRoutingFeatures = "both";
    };

    services.cachefilesd = {
      enable = true;
      extraConfig = ''
        brun 20%
        bcull 10%
        bstop 5%
      '';
    };
  };
}
