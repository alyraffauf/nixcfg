{lib, ...}: {
  imports = [
    ./nix
    ./restic
    ./ssh
    ./syncthing
  ];

  options.mySnippets.tailnet = lib.mkOption {
    default = "narwhal-snapper.ts.net";
    description = "Tailnet name.";
    type = lib.types.str;
  };
}
