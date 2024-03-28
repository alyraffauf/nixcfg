{ pkgs, lib, config, ... }: {

  options = { cliApps.emacs.enable = lib.mkEnableOption "Enables emacs."; };

  config = lib.mkIf config.cliApps.emacs.enable {
    home.packages = with pkgs; [ nixfmt python3 ];

    programs.emacs = {
      enable = true;
      extraPackages = (epkgs:
        (with epkgs; [
          better-defaults
          catppuccin-theme
          markdown-mode
          nix-mode
          org
          org-bullets
          org-journal
          org-roam
          ox-pandoc
          projectile
          python
          treemacs
          treemacs-projectile
          treemacs-tab-bar
          use-package
          yaml
          yaml-mode
        ]));
      package = pkgs.emacs-nox;
      extraConfig = builtins.readFile ./emacs.el;
    };
  };
}
