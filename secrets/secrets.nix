let
  users = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA5xWjZIdMQaQE7vyPP7VRAKNHbrFeh0QtF3bAXni66V aly@lavaridge"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIXlNHLi7aWZ+4/P9TN1wYzFvw5R01GYF/YC1Dl6Z/VJ aly@rustboro"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJBK+QkM3C98BxnJtcEOuxjT7bbUG8gsUafrzW9uKuxz aly@petalburg"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINBGJ03i6Bgnc/Fv6IDfQH8JtBW3435SJLaZX7WzgWBw aly@fallarbor"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINHdpGTfjmnnau18CowChY4hPn/fzRkgJvXFs+yPy74I aly@mauville"
  ];

  fallarbor = builtins.readFile ../hosts/fallarbor/ssh.pub;
  lavaridge = builtins.readFile ../hosts/lavaridge/ssh.pub;
  mauville = builtins.readFile ../hosts/mauville/ssh.pub;
  petalburg = builtins.readFile ../hosts/petalburg/ssh.pub;
  rustboro = builtins.readFile ../hosts/rustboro/ssh.pub;

  systems = [
    fallarbor
    lavaridge
    mauville
    petalburg
    rustboro
  ];
in {
  "hosts/fallarbor/syncthing/cert.age".publicKeys = users ++ systems;
  "hosts/fallarbor/syncthing/key.age".publicKeys = users ++ systems;
  "hosts/lavaridge/syncthing/cert.age".publicKeys = users ++ systems;
  "hosts/lavaridge/syncthing/key.age".publicKeys = users ++ systems;
  "hosts/mauville/syncthing/cert.age".publicKeys = users ++ systems;
  "hosts/mauville/syncthing/key.age".publicKeys = users ++ systems;
  "hosts/petalburg/syncthing/cert.age".publicKeys = users ++ systems;
  "hosts/petalburg/syncthing/key.age".publicKeys = users ++ systems;
  "hosts/rustboro/syncthing/cert.age".publicKeys = users ++ systems;
  "hosts/rustboro/syncthing/key.age".publicKeys = users ++ systems;
  "spotify/clientId.age".publicKeys = users ++ systems;
  "spotify/clientSecret.age".publicKeys = users ++ systems;
  "tailscale/authKeyFile.age".publicKeys = users ++ systems;
  "wifi.age".publicKeys = users ++ systems;
}
