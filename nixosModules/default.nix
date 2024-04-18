{
  config,
  pkgs,
  ...
}: {
  imports = [./apps ./desktop ./homeLab ./systemConfig ./userConfig];
}
