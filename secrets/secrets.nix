let
  hosts = [
    "fallarbor"
    "lavaridge"
    "mauville"
    "mandarin"
    "petalburg"
    "rustboro"
  ];
  users = [
    "aly_lavaridge"
    "aly_mauville"
    "aly_petalburg"
    "aly_rustboro"
  ];
  systemKeys = builtins.map (host: builtins.readFile ./publicKeys/root_${host}.pub) hosts;
  userKeys = builtins.map (user: builtins.readFile ./publicKeys/${user}.pub) users;
  keys = systemKeys ++ userKeys;
in {
  "cloudflare.age".publicKeys = keys;
  "lastFM/apiKey.age".publicKeys = keys;
  "lastFM/secret.age".publicKeys = keys;
  "mail/achacega_gmail.age".publicKeys = keys;
  "mail/alyraffauf_fastmail.age".publicKeys = keys;
  "nixCache/privKey.age".publicKeys = keys;
  "runners/codeberg.age".publicKeys = keys;
  "runners/raffauflabs.age".publicKeys = keys;
  "spotify/clientId.age".publicKeys = keys;
  "spotify/clientSecret.age".publicKeys = keys;
  "syncthing/fallarbor/cert.age".publicKeys = keys;
  "syncthing/fallarbor/key.age".publicKeys = keys;
  "syncthing/lavaridge/cert.age".publicKeys = keys;
  "syncthing/lavaridge/key.age".publicKeys = keys;
  "syncthing/mauville/cert.age".publicKeys = keys;
  "syncthing/mauville/key.age".publicKeys = keys;
  "syncthing/petalburg/cert.age".publicKeys = keys;
  "syncthing/petalburg/key.age".publicKeys = keys;
  "syncthing/rustboro/cert.age".publicKeys = keys;
  "syncthing/rustboro/key.age".publicKeys = keys;
  "tailscale/authKeyFile.age".publicKeys = keys;
  "wifi.age".publicKeys = keys;
}
