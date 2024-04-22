{
  config,
  pkgs,
  ...
}: {
  imports = [./apps ./desktop ./homeLab ./services ./system ./user];
}
