{
  pkgs,
  self,
  ...
}: {
  environment.systemPackages = with pkgs; [git inxi python3];
}
