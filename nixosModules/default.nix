{
  config,
  pkgs,
  ...
}: {
  imports = [./apps ./containers ./desktop ./services ./system ./user];
}
