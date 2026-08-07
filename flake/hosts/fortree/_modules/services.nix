_: {
  services = {
    openssh.enable = true;

    tailscale = {
      enable = true;
      overrideLocalDns = true;
    };
  };

  sops.age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
}
