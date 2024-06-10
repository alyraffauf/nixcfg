{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.user.aly = {
      enable = lib.mkEnableOption "Enables Aly's user.";
      password = lib.mkOption {
        description = "Hashed password for user aly.";
        type = lib.types.str;
      };
    };
  };

  config = lib.mkIf config.alyraffauf.user.aly.enable {
    users.users.aly = {
      description = "Aly Raffauf";
      extraGroups = ["networkmanager" "wheel" "docker" "libvirtd" "video"];
      hashedPassword = config.alyraffauf.user.aly.password;
      isNormalUser = true;
      linger = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGcJBb7+ZxkDdk06A0csNsbgT9kARUN185M8k3Lq7E/d u0_a336@localhost" # termux on winona
        (builtins.readFile ../../../secrets/publicKeys/aly_lavaridge.pub)
        (builtins.readFile ../../../secrets/publicKeys/aly_mauville.pub)
        (builtins.readFile ../../../secrets/publicKeys/aly_petalburg.pub)
        (builtins.readFile ../../../secrets/publicKeys/aly_rustboro.pub)
      ];
    };
  };
}
