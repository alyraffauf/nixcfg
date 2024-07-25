{config, ...}: {
  age.secrets = {
    achacegaGmail.file = ../../secrets/aly/mail/achacega_gmail.age;
    alyraffaufFastmail.file = ../../secrets/aly/mail/alyraffauf_fastmail.age;
    backblazeKeyId.file = ../../secrets/aly/backblaze/keyId.age;
    backblazeKey.file = ../../secrets/aly/backblaze/key.age;

    transmissionRemote = {
      file = ../../secrets/aly/transmissionRemote.age;
      path = "${config.home.homeDirectory}/.config/transmission-remote-gtk/config.json";
    };
  };
}
