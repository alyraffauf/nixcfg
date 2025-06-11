{self, ...}: {
  home-manager.users.aly = self.homeManagerModules.aly;

  home-manager.sharedModules = [
    {
      stylix.targets = {
        bat.enable = true;
        font-packages.enable = true;
        fontconfig.enable = true;
        ghostty.enable = true;
        helix.enable = true;
        vesktop.enable = true;
        vscode.enable = true;
        zellij.enable = true;
      };
    }
  ];
}
