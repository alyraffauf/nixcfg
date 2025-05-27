{self, ...}: {
  age.secrets = {
    achacegaGmail.file = "${self.inputs.secrets}/aly/mail/gmail.age";
    alyraffaufFastmail.file = "${self.inputs.secrets}/aly/mail/fastmail.age";
    aws.file = "${self.inputs.secrets}/aly/aws.age";
    rclone-b2.file = "${self.inputs.secrets}/rclone/b2.age";
    rclone-icloud.file = "${self.inputs.secrets}/aly/rclone/icloud.age";
  };
}
