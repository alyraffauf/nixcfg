skillDirectory:
builtins.path {
  path = skillDirectory;
  filter = path: _: baseNameOf path != "default.nix";
}
