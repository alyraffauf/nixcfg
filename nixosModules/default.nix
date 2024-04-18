{
  config,
  pkgs,
  ...
}: {
  imports = [./apps ./desktop ./homeLab ./system ./user];
}
