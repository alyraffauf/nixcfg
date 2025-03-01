{
  config,
  self,
  ...
}: {
  age.secrets = {
    achacegaGmail.file = "${self.inputs.secrets}/aly/mail/achacega_gmail.age";
    alyraffaufFastmail.file = "${self.inputs.secrets}/aly/mail/alyraffauf_fastmail.age";
    rclone-b2.file = "${self.inputs.secrets}/aly/rclone/b2.age";
    rclone-icloud.file = "${self.inputs.secrets}/aly/rclone/icloud.age";

    transmissionRemote = {
      file = "${self.inputs.secrets}/aly/transmissionRemote.age";
      path = "${config.home.homeDirectory}/.config/transmission-remote-gtk/config.json";
    };
  };
}
