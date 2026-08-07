{lib, ...}: {
  imports = [
    ./base
    ./programs
  ];

  options.myDarwin.FLAKE = lib.mkOption {
    type = lib.types.str;
    default = "github:alyraffauf/nixcfg";
    description = "Default flake URL for this nix-darwin configuration.";
  };
}
