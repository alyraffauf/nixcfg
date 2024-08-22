{
  pkgs,
  self,
  ...
}: {
  environment.systemPackages = (with pkgs; [git inxi python3]) ++ [self.inputs.agenix.packages.${pkgs.system}.default];
}
