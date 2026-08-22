{lib, ...}: let
  nfsOptions = [
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

  nfsMount = path: {
    device = "goldenrod:${path}";
    fsType = "nfs";
    options = nfsOptions;
  };
in {
  options.flake.darwinModules.tailscale = lib.mkOption {
    type = lib.types.deferredModule;
    default = {};
  };

  config.flake = {
    darwinModules.tailscale = {
      networking = {
        # Explicitly manage these
        knownNetworkServices = [
          "Wi-Fi"
          "Ethernet Adaptor"
          "Thunderbolt Ethernet"
        ];

        # Otherwise tailscale ssh only works with FQDNs
        search = ["narwhal-snapper.ts.net"];
      };

      services.tailscale = {
        enable = true;
        # Needs a declared DNS provider in Tailscale's admin panel
        overrideLocalDns = true;
      };
    };

    nixosModules.tailscale = {
      config,
      pkgs,
      self,
      ...
    }: {
      environment.systemPackages = [pkgs.nfs-utils];

      fileSystems = {
        "/mnt/Data" = nfsMount "/mnt/Data";
        "/mnt/Media" = nfsMount "/mnt/Media";
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
  };
}
