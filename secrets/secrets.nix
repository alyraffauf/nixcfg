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
  "hosts/fallarbor/syncthing/cert.age".publicKeys = keys;
  "hosts/fallarbor/syncthing/key.age".publicKeys = keys;
  "hosts/lavaridge/syncthing/cert.age".publicKeys = keys;
  "hosts/lavaridge/syncthing/key.age".publicKeys = keys;
  "hosts/mauville/syncthing/cert.age".publicKeys = keys;
  "hosts/mauville/syncthing/key.age".publicKeys = keys;
  "hosts/petalburg/syncthing/cert.age".publicKeys = keys;
  "hosts/petalburg/syncthing/key.age".publicKeys = keys;
  "hosts/rustboro/syncthing/cert.age".publicKeys = keys;
  "hosts/rustboro/syncthing/key.age".publicKeys = keys;
  "spotify/clientId.age".publicKeys = keys;
  "spotify/clientSecret.age".publicKeys = keys;
  "lastFM/apiKey.age".publicKeys = keys;
  "lastFM/secret.age".publicKeys = keys;
  "tailscale/authKeyFile.age".publicKeys = keys;
  "wifi.age".publicKeys = keys;
}
