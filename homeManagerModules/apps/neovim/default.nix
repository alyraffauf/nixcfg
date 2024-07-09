{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [self.inputs.nixvim.homeManagerModules.nixvim];

  config = lib.mkIf config.ar.home.apps.neovim.enable {
    programs.nixvim = {
      enable = true;
      colorschemes.ayu.enable = true;

      plugins = {
        lightline.enable = true;
        markdown-preview.enable = true;
        neo-tree.enable = true;
        neogit.enable = true;
        nix.enable = true;
      };
    };
  };
}
