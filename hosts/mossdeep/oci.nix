{...}: {
  virtualisation.oci-containers = {
    backend = "podman";

    containers = {
      alycodes = {
        extraOptions = ["--pull=always"];
        image = "ghcr.io/alyraffauf/aly.codes";
        ports = ["0.0.0.0:8282:80"];
      };
    };
  };
}
