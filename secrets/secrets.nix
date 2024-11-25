let
  hosts = [
    "fallarbor"
    "lavaridge"
    "mauville"
    "pacifidlog"
    "petalburg"
    "rustboro"
    "slateport"
  ];
  users = [
    "aly_fallarbor"
    "aly_lavaridge"
    "aly_mauville"
    "aly_pacifidlog"
    "aly_rustboro"
    "aly_slateport"
  ];
  systemKeys = builtins.map (host: builtins.readFile ./publicKeys/root_${host}.pub) hosts;
  userKeys = builtins.map (user: builtins.readFile ./publicKeys/${user}.pub) users;
  keys = systemKeys ++ userKeys;
in {
  "aly/backblaze/key.age".publicKeys = keys;
  "aly/backblaze/keyId.age".publicKeys = keys;
  "aly/mail/achacega_gmail.age".publicKeys = keys;
  "aly/mail/alyraffauf_fastmail.age".publicKeys = keys;
  "aly/syncthing/fallarbor/cert.age".publicKeys = keys;
  "aly/syncthing/fallarbor/key.age".publicKeys = keys;
  "aly/syncthing/lavaridge/cert.age".publicKeys = keys;
  "aly/syncthing/lavaridge/key.age".publicKeys = keys;
  "aly/syncthing/mauville/cert.age".publicKeys = keys;
  "aly/syncthing/mauville/key.age".publicKeys = keys;
  "aly/syncthing/pacifidlog/cert.age".publicKeys = keys;
  "aly/syncthing/pacifidlog/key.age".publicKeys = keys;
  "aly/syncthing/petalburg/cert.age".publicKeys = keys;
  "aly/syncthing/petalburg/key.age".publicKeys = keys;
  "aly/syncthing/rustboro/cert.age".publicKeys = keys;
  "aly/syncthing/rustboro/key.age".publicKeys = keys;
  "aly/syncthing/slateport/cert.age".publicKeys = keys;
  "aly/syncthing/slateport/key.age".publicKeys = keys;
  "aly/transmissionRemote.age".publicKeys = keys;
  "cloudflare.age".publicKeys = keys;
  "homepage.age".publicKeys = keys;
  "k3s.age".publicKeys = keys;
  "lastFM/apiKey.age".publicKeys = keys;
  "lastFM/secret.age".publicKeys = keys;
  "spotify/clientId.age".publicKeys = keys;
  "spotify/clientSecret.age".publicKeys = keys;
  "tailscale/authKeyFile.age".publicKeys = keys;
  "transmission.age".publicKeys = keys;
  "wifi.age".publicKeys = keys;
}
