{config, ...}: {
  age.secrets = {
    achacegaGmail.file = ../../secrets/mail/achacega_gmail.age;
    alyraffaufFastmail.file = ../../secrets/mail/alyraffauf_fastmail.age;
    backblazeKeyId.file = ../../secrets/backblaze/keyId.age;
    backblazeKey.file = ../../secrets/backblaze/key.age;

    transmissionRemote = {
      file = ../../secrets/transmissionRemote.age;
      path = "${config.home.homeDirectory}/.config/transmission-remote-gtk/config.json";
    };
  };
}
