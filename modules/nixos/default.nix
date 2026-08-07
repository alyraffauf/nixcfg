{lib, ...}: {
  imports = [
    ./base
    ./desktop
    ./profiles
    ./programs
    ./services
  ];

  options.myNixOS.FLAKE = lib.mkOption {
    type = lib.types.str;
    default = "github:alyraffauf/nixcfg";
    description = "Default flake URL for this NixOS configuration.";
  };
}
