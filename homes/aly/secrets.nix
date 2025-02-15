{config, ...}: {
  age.secrets = {
    achacegaGmail.file = ../../secrets/aly/mail/achacega_gmail.age;
    alyraffaufFastmail.file = ../../secrets/aly/mail/alyraffauf_fastmail.age;
    rclone-b2.file = ../../secrets/rclone/b2.age;

    transmissionRemote = {
      file = ../../secrets/aly/transmissionRemote.age;
      path = "${config.home.homeDirectory}/.config/transmission-remote-gtk/config.json";
    };
  };
}
