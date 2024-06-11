let
  hosts = [
    "fallarbor"
    "lavaridge"
    "mauville"
    "petalburg"
    "rustboro"
  ];
  systemKeys = builtins.map (host: builtins.readFile ./publicKeys/root_${host}.pub) hosts;
  userKeys = builtins.map (host: builtins.readFile ./publicKeys/aly_${host}.pub) hosts;
  keys = systemKeys ++ userKeys;
in {
  "lastFM/apiKey.age".publicKeys = keys;
  "lastFM/secret.age".publicKeys = keys;
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
