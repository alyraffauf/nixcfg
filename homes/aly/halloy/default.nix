{
  config,
  lib,
  self,
  ...
}: {
  age.secrets.halloy = {
    file = "${self.inputs.secrets}/aly/halloy.age";
    path = "${config.xdg.configHome}/halloy/config.toml";
  };

  programs.halloy = {
    enable = true;
    settings = lib.mkForce {};
  };
}
