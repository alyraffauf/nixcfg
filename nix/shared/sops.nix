_: let
  module = {
    sops.age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  };
in {
  flake = {
    nixosModules.default = module;
    darwinModules.default = module;
  };
}
