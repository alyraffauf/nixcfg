{config, ...}: {
  services = {
    pds = {
      enable = true;
      environmentFiles = [config.age.secrets.pds.path];
      pdsadmin.enable = true;
      settings.PDS_HOSTNAME = "aly.social";
    };
  };

  systemd.services.podman-alycodes.after = ["forgejo.service"];
}
