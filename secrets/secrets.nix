let
  keys = [
    (builtins.readFile ./publicKeys/aly_fallarbor.pub)
    (builtins.readFile ./publicKeys/aly_lavaridge.pub)
    (builtins.readFile ./publicKeys/aly_mauville.pub)
    (builtins.readFile ./publicKeys/aly_petalburg.pub)
    (builtins.readFile ./publicKeys/aly_rustboro.pub)
    (builtins.readFile ./publicKeys/root_fallarbor.pub)
    (builtins.readFile ./publicKeys/root_lavaridge.pub)
    (builtins.readFile ./publicKeys/root_mauville.pub)
    (builtins.readFile ./publicKeys/root_petalburg.pub)
    (builtins.readFile ./publicKeys/root_rustboro.pub)
  ];
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
