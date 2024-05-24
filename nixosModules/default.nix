inputs: {
  config,
  pkgs,
  ...
}: {
  imports = [./apps ./containers ./desktop ./scripts ./services ./system ./user];
}
