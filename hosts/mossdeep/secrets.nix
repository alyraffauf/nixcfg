{self, ...}: {
  age.secrets = {
    cloudflare.file = "${self.inputs.secrets}/cloudflare.age";
    forgejo-mailer-passwd.file = "${self.inputs.secrets}/forgejo/passwd.age";
    pds.file = "${self.inputs.secrets}/pds.age";
    postgres-forgejo.file = "${self.inputs.secrets}/postgresql/forgejo.age";
    rclone-b2.file = "${self.inputs.secrets}/rclone/b2.age";
    restic-passwd.file = "${self.inputs.secrets}/restic-password.age";
    tailscaleAuthKey.file = "${self.inputs.secrets}/tailscale/auth.age";
  };
}
