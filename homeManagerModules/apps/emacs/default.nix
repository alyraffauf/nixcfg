{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.ar.home.apps.emacs.enable {
    programs.emacs = {
      enable = true;
      extraConfig = builtins.readFile ./emacs.el;

      extraPackages = epkgs: (with epkgs; [
        better-defaults
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
      ]);

      package = pkgs.emacs-nox;
    };
  };
}
