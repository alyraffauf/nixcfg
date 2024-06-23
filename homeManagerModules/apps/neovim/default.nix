{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.apps.neovim.enable {
    programs.nixvim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      colorschemes.catppuccin = {
        enable = true;
        settings.flavor = "frappe";
      };

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
