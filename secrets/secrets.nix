let
  users = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA5xWjZIdMQaQE7vyPP7VRAKNHbrFeh0QtF3bAXni66V aly@lavaridge"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIXlNHLi7aWZ+4/P9TN1wYzFvw5R01GYF/YC1Dl6Z/VJ aly@rustboro"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJBK+QkM3C98BxnJtcEOuxjT7bbUG8gsUafrzW9uKuxz aly@petalburg"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINHdpGTfjmnnau18CowChY4hPn/fzRkgJvXFs+yPy74I aly@mauville"
  ];

  systems = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHjcWpeYMjNaICoHwedu3tBt7/5tKxXQHCKaUx4ez4jm root@petalburg"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIHMOi6qdkhR5u8/3arkXCMg8W2kqZVy1HgDfBR5uGHG root@mauville"
  ];
in {
  "wifi/Stargate-Discovery.age".publicKeys = users ++ systems;
  "wifi/wattson.age".publicKeys = users ++ systems;
}
