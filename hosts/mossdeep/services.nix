{config, ...}: {
  services = {
    pds = {
      enable = true;
      environmentFiles = [config.age.secrets.pds.path];
      pdsadmin.enable = true;
      settings.PDS_HOSTNAME = config.mySnippets.cute-haus.networkMap.aly-social.vHost;
    };
  };

  systemd.services.podman-alycodes.after = ["forgejo.service"];
}
