{
  config,
  lib,
  ...
}: {
  options.myNixOS.services.alycodes = {
    enable = lib.mkEnableOption "aly.codes personal website";

    port = lib.mkOption {
      description = "Port to listen on.";
      default = 8282;
      type = lib.types.int;
    };
  };

  config = lib.mkIf config.myNixOS.services.alycodes.enable {
    virtualisation.oci-containers = {
      backend = "podman";

      containers = {
        alycodes = {
          extraOptions = ["--pull=always"];
          image = "git.aly.codes/alyraffauf/aly.codes";
          ports = ["0.0.0.0:${toString config.myNixOS.services.alycodes.port}:80"];
        };

        # alycodes-react = {
        #   extraOptions = ["--pull=always"];
        #   image = "ghcr.io/alyraffauf/alycodes-react";
        #   ports = ["0.0.0.0:5738:80"];
        # };

        myatmosphere = {
          extraOptions = ["--pull=always"];
          image = "ghcr.io/alyraffauf/myatmosphere";
          ports = ["0.0.0.0:5739:80"];
        };
      };
    };

    myNixOS.programs.podman.enable = true;
  };
}
