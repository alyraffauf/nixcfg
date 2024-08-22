{
  lib,
  self,
  ...
}: {
  home-manager.users.aly = lib.mkForce self.homeManagerModules.aly-nox;
}
