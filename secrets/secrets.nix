let
  users = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA5xWjZIdMQaQE7vyPP7VRAKNHbrFeh0QtF3bAXni66V aly@lavaridge"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIXlNHLi7aWZ+4/P9TN1wYzFvw5R01GYF/YC1Dl6Z/VJ aly@rustboro"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJBK+QkM3C98BxnJtcEOuxjT7bbUG8gsUafrzW9uKuxz aly@petalburg"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINBGJ03i6Bgnc/Fv6IDfQH8JtBW3435SJLaZX7WzgWBw aly@fallarbor"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINHdpGTfjmnnau18CowChY4hPn/fzRkgJvXFs+yPy74I aly@mauville"
  ];

  systems = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDE5RuHBUz1GW0AwOwgjj/HRBXcAUdVXkh3LopdauQF9 root@fallarbor"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHjcWpeYMjNaICoHwedu3tBt7/5tKxXQHCKaUx4ez4jm root@petalburg"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHw+EYVVKOzIIlvF2Bp625q6OQMVXnQTxZSo16YjRovW root@lavaridge"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIHMOi6qdkhR5u8/3arkXCMg8W2kqZVy1HgDfBR5uGHG root@mauville"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMs1oChR4z/gzFkuKddB+1XrwfG2znlWbdnP+hNAdNdN root@rustboro"
  ];
in {
  "spotify/clientId.age".publicKeys = users ++ systems;
  "spotify/clientSecret.age".publicKeys = users ++ systems;
  "tailscale/authKeyFile.age".publicKeys = users ++ systems;
  "wifi/Stargate-Discovery.age".publicKeys = users ++ systems;
  "wifi/wattson.age".publicKeys = users ++ systems;
}
