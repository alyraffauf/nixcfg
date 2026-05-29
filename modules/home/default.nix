{
  config,
  self,
  ...
}: {
  imports = [
    ./aly
    ./desktop
    ./profiles
    ./programs
    ./services
    self.inputs.cosmic-manager.homeManagerModules.cosmic-manager
    self.inputs.snippets.homeModules.snippets
    self.inputs.sops-nix.homeManagerModules.sops
  ];

  sops.age.sshKeyPaths = ["${config.home.homeDirectory}/.ssh/id_ed25519"];
}
