{self, ...}: {
  home-manager.users.aly = self.homeConfigurations.aly;

  home-manager.sharedModules = [
    {
      stylix.targets = {
        bat.enable = true;
        font-packages.enable = true;
        fontconfig.enable = true;
        ghostty.enable = true;
        helix.enable = true;
        vscode.enable = true;
        zed.enable = true;
        zellij.enable = true;
      };
    }
  ];
}
