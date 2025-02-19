{config, ...}: {
  age.secrets = {
    achacegaGmail.file = ../../secrets/aly/mail/achacega_gmail.age;
    alyraffaufFastmail.file = ../../secrets/aly/mail/alyraffauf_fastmail.age;
    rclone-b2.file = ../../secrets/aly/rclone/b2.age;
    rclone-icloud.file = ../../secrets/aly/rclone/icloud.age;

    transmissionRemote = {
      file = ../../secrets/aly/transmissionRemote.age;
      path = "${config.home.homeDirectory}/.config/transmission-remote-gtk/config.json";
    };
  };
}
