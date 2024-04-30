{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.user.aly.enable = lib.mkEnableOption "Enables Aly's user.";
    alyraffauf.user.aly.password = lib.mkOption {
      description = "Hashed password for user aly.";
      type = lib.types.str;
    };
  };

  config = lib.mkIf config.alyraffauf.user.aly.enable {
    users.users.aly = {
      isNormalUser = true;
      description = "Aly Raffauf";
      extraGroups = ["networkmanager" "wheel" "docker" "libvirtd" "video"];
      hashedPassword = config.alyraffauf.user.aly.password;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOuRiyf9Fbl3Plqqzy5YkE2UJv8evF8YI9eG7Iu2CIRa aly@petalburg"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINHdpGTfjmnnau18CowChY4hPn/fzRkgJvXFs+yPy74I aly@mauville"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJVI6aNp95f/xsg6N+PRplmGi9MYGnfniL9/jdza3GXt aly@lavaridge"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGcJBb7+ZxkDdk06A0csNsbgT9kARUN185M8k3Lq7E/d u0_a336@localhost" # termux on winona
      ];
    };
  };
}
